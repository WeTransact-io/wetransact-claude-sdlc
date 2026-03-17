#!/usr/bin/bash
# Hook: Orchestration Snapshot (PreCompact)
# Event: PreCompact (manual|auto)
# Purpose: Before context compaction, captures the current orchestration state
#          into _compact_snapshot.md so that context_reinject.sh can restore it
#          after compaction. Also updates orchestration task files with the latest
#          implementation task state extracted from the session transcript.
#
# Integration:
#   - Writes: .claude/tasks/_compact_snapshot.md
#   - Updates: .claude/tasks/<active-orchestration>.md (adds last_compaction timestamp)
#   - Consumed by: context_reinject.sh (SessionStart compact hook)
#
# Note: PreCompact hooks CANNOT block compaction. This hook runs side-effect only.

TMPFILE=$(mktemp)
cat > "$TMPFILE"

SCRIPTFILE=$(mktemp)
cat > "$SCRIPTFILE" <<'NODESCRIPT'
  const fs = require('fs');
  const path = require('path');
  const inputFile = process.argv[1];
  const d = fs.readFileSync(inputFile, 'utf8');
  fs.unlinkSync(inputFile);

  try {
    const input = JSON.parse(d);
    const cwd = input.cwd || '';
    const transcriptPath = input.transcript_path || '';
    const trigger = input.trigger || 'auto';
    const tasksDir = path.join(cwd, '.claude', 'tasks');

    // No tasks directory = no orchestration possible, exit silently
    if (!fs.existsSync(tasksDir)) {
      process.exit(0);
    }

    // Find active (non-completed) orchestration files
    const taskFiles = fs.readdirSync(tasksDir)
      .filter(f => f.endsWith('.md') && f !== 'README.md' && !f.startsWith('_'))
      .map(f => {
        const fullPath = path.join(tasksDir, f);
        const content = fs.readFileSync(fullPath, 'utf8');
        const statusMatch = content.match(/status:\s*(\w+)/);
        const status = statusMatch ? statusMatch[1] : 'unknown';
        return { name: f, path: fullPath, content, status, mtime: fs.statSync(fullPath).mtimeMs };
      })
      .filter(f => f.status !== 'completed')
      .sort((a, b) => b.mtime - a.mtime);

    // No active orchestration = nothing to snapshot
    if (taskFiles.length === 0) {
      // Clean up stale snapshot if one exists
      const snapshotPath = path.join(tasksDir, '_compact_snapshot.md');
      if (fs.existsSync(snapshotPath)) {
        fs.unlinkSync(snapshotPath);
      }
      process.exit(0);
    }

    // Use the most recent active orchestration file
    const activeTask = taskFiles[0];
    const content = activeTask.content;

    // ============================
    // PHASE 1: Extract metadata
    // ============================
    const featureMatch = content.match(/feature:\s*(.+)/);
    const featureName = featureMatch ? featureMatch[1].trim() : 'Unknown';

    const totalMatch = content.match(/total_units:\s*(\d+)/);
    const totalUnits = totalMatch ? totalMatch[1] : '?';

    const completedMatch = content.match(/completed_units:\s*(\d+)/);
    const completedUnits = completedMatch ? completedMatch[1] : '?';

    const planMatch = content.match(/Plan Source:\s*`?([^`\n]+)`?/);
    const planSource = planMatch ? planMatch[1].trim() : '';

    // Helper: extract a markdown section by heading
    function extractSection(text, heading) {
      // Match the heading and everything until the next ## heading or end of file
      const regex = new RegExp('(## ' + heading.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')([\\s\\S]*?)(?=\\n## |$)');
      const match = text.match(regex);
      return match ? (match[1] + match[2]).trim() : '';
    }

    const progressSummary = extractSection(content, 'Progress Summary');
    const waveBreakdown = extractSection(content, 'Wave Breakdown');
    const activeUnits = extractSection(content, 'Active Units');
    const blockedUnits = extractSection(content, 'Blocked Units');
    const completedUnitsSection = extractSection(content, 'Completed Units');
    const notes = extractSection(content, 'Notes');

    // ============================
    // PHASE 2: Extract recent task operations from transcript
    // ============================
    let recentTaskOps = [];
    let recentSubAgents = [];
    let lastProgressNotes = [];

    if (transcriptPath && fs.existsSync(transcriptPath)) {
      try {
        const transcriptContent = fs.readFileSync(transcriptPath, 'utf8');
        const lines = transcriptContent.trim().split('\n');
        // Read last 150 lines for recent activity
        const recentLines = lines.slice(-150);

        for (const line of recentLines) {
          try {
            const entry = JSON.parse(line);
            const text = JSON.stringify(entry);

            // Extract TaskUpdate/TaskCreate operations
            if (text.includes('TaskUpdate') || text.includes('TaskCreate')) {
              const taskIdMatch = text.match(/"taskId"\s*:\s*"([^"]+)"/);
              const statusMatch = text.match(/"status"\s*:\s*"([^"]+)"/);
              const subjectMatch = text.match(/"subject"\s*:\s*"([^"]+)"/);
              if (taskIdMatch) {
                recentTaskOps.push({
                  taskId: taskIdMatch[1],
                  status: statusMatch ? statusMatch[1] : '',
                  subject: subjectMatch ? subjectMatch[1] : ''
                });
              }
            }

            // Extract sub-agent dispatches
            if (text.includes('"subagent_type"')) {
              const agentMatch = text.match(/"subagent_type"\s*:\s*"([^"]+)"/);
              const descMatch = text.match(/"description"\s*:\s*"([^"]+)"/);
              if (agentMatch) {
                recentSubAgents.push({
                  agent: agentMatch[1],
                  desc: descMatch ? descMatch[1] : ''
                });
              }
            }

            // Extract progress-related assistant messages
            if (entry.role === 'assistant' && typeof entry.content === 'string') {
              const c = entry.content.toLowerCase();
              if (c.includes('wave') || c.includes('unit') || c.includes('completed') || c.includes('dispatching')) {
                const snippet = entry.content.substring(0, 200).replace(/\n/g, ' ');
                lastProgressNotes.push(snippet);
              }
            }
          } catch(e) {}
        }
      } catch(e) {
        process.stderr.write('Warning: Could not read transcript for task state extraction\n');
      }
    }

    // Deduplicate sub-agents (keep last 5 unique)
    const uniqueAgents = [];
    const seenAgents = new Set();
    for (let i = recentSubAgents.length - 1; i >= 0 && uniqueAgents.length < 5; i--) {
      const key = recentSubAgents[i].agent + ':' + recentSubAgents[i].desc;
      if (!seenAgents.has(key)) {
        seenAgents.add(key);
        uniqueAgents.unshift(recentSubAgents[i]);
      }
    }

    // Deduplicate task ops (keep latest state per taskId)
    const taskOpsMap = new Map();
    for (const op of recentTaskOps) {
      taskOpsMap.set(op.taskId, op);
    }
    const latestTaskOps = Array.from(taskOpsMap.values()).slice(-10);

    // Keep last 3 progress notes
    const recentProgress = lastProgressNotes.slice(-3);

    // ============================
    // PHASE 3: Update orchestration task file with latest state
    // ============================

    // Update the orchestration file's frontmatter with compaction timestamp
    let updatedContent = content;
    const frontmatterMatch = updatedContent.match(/^---\n([\s\S]*?)\n---/);
    if (frontmatterMatch) {
      let frontmatter = frontmatterMatch[1];
      if (frontmatter.includes('last_compaction:')) {
        frontmatter = frontmatter.replace(/last_compaction:\s*.+/, 'last_compaction: ' + new Date().toISOString());
      } else {
        frontmatter += '\nlast_compaction: ' + new Date().toISOString();
      }
      updatedContent = updatedContent.replace(
        /^---\n[\s\S]*?\n---/,
        '---\n' + frontmatter + '\n---'
      );
    }

    // If we have live task state from transcript, append it to the Notes section
    if (latestTaskOps.length > 0) {
      const taskStateNote = '\n- [Pre-compact ' + new Date().toISOString().slice(0, 16) + '] Live task IDs: ' +
        latestTaskOps.map(op => op.taskId + '(' + (op.status || '?') + ')').join(', ');

      if (updatedContent.includes('## Notes')) {
        updatedContent = updatedContent.replace(
          /(## Notes[\s\S]*?)$/,
          '$1' + taskStateNote + '\n'
        );
      } else {
        updatedContent += '\n## Notes' + taskStateNote + '\n';
      }
    }

    fs.writeFileSync(activeTask.path, updatedContent, 'utf8');

    // ============================
    // PHASE 4: Build _compact_snapshot.md
    // ============================
    const snapshot = [];
    snapshot.push('---');
    snapshot.push('feature: ' + featureName);
    snapshot.push('source_file: ' + activeTask.name);
    snapshot.push('snapshot_time: ' + new Date().toISOString());
    snapshot.push('trigger: ' + trigger);
    snapshot.push('total_units: ' + totalUnits);
    snapshot.push('completed_units: ' + completedUnits);
    if (planSource) snapshot.push('plan_source: ' + planSource);
    snapshot.push('---');
    snapshot.push('');
    snapshot.push('# Pre-Compaction Orchestration Snapshot');
    snapshot.push('');

    // Resume instructions (consumed by context_reinject.sh)
    snapshot.push('## RESUME INSTRUCTIONS');
    snapshot.push('');
    snapshot.push('This snapshot was created before context compaction (' + trigger + ' trigger).');
    snapshot.push('An orchestration workflow was actively running and MUST be resumed.');
    snapshot.push('');
    snapshot.push('**MANDATORY ACTIONS (in order):**');
    snapshot.push('1. Read the FULL orchestration file: `.claude/tasks/' + activeTask.name + '`');
    snapshot.push('2. Run `TaskList` to get current built-in task system state');
    snapshot.push('3. Cross-reference built-in tasks with orchestration units to determine true current state');
    snapshot.push('4. Identify all units that are READY to execute (pending + dependencies satisfied)');
    snapshot.push('5. Dispatch ALL ready units in parallel using the Task tool with appropriate sub-agents');
    snapshot.push('6. Continue wave-based execution until all units complete');
    snapshot.push('');
    snapshot.push('**DO NOT** ask the user what to do. The orchestration was interrupted by compaction and MUST resume automatically.');
    snapshot.push('');

    // Progress summary
    if (progressSummary) {
      snapshot.push(progressSummary);
      snapshot.push('');
    }

    // Wave breakdown
    if (waveBreakdown) {
      snapshot.push(waveBreakdown);
      snapshot.push('');
    }

    // Active units
    if (activeUnits) {
      snapshot.push(activeUnits);
      snapshot.push('');
    }

    // Blocked units
    if (blockedUnits) {
      snapshot.push(blockedUnits);
      snapshot.push('');
    }

    // Completed units
    if (completedUnitsSection) {
      snapshot.push(completedUnitsSection);
      snapshot.push('');
    }

    // Live task state from transcript
    if (latestTaskOps.length > 0) {
      snapshot.push('## Live Task State');
      snapshot.push('');
      snapshot.push('Task system operations captured from session transcript before compaction:');
      snapshot.push('');
      snapshot.push('| Task ID | Subject | Last Status |');
      snapshot.push('|---------|---------|-------------|');
      for (const op of latestTaskOps) {
        snapshot.push('| ' + op.taskId + ' | ' + (op.subject || '-') + ' | ' + (op.status || '-') + ' |');
      }
      snapshot.push('');
    }

    // Recently dispatched sub-agents
    if (uniqueAgents.length > 0) {
      snapshot.push('## Recently Dispatched Sub-Agents');
      snapshot.push('');
      snapshot.push('| Agent Type | Description |');
      snapshot.push('|-----------|-------------|');
      for (const a of uniqueAgents) {
        snapshot.push('| ' + a.agent + ' | ' + (a.desc || '-') + ' |');
      }
      snapshot.push('');
    }

    // Last progress report from assistant messages
    if (recentProgress.length > 0) {
      snapshot.push('## Last Progress Report');
      snapshot.push('');
      snapshot.push('Recent orchestration progress notes (from conversation):');
      snapshot.push('');
      for (const note of recentProgress) {
        snapshot.push('> ' + note);
        snapshot.push('');
      }
    }

    // Notes from orchestration file
    if (notes) {
      snapshot.push('## Orchestration Notes');
      snapshot.push('');
      snapshot.push(notes.replace(/^## Notes\s*/, '').trim());
      snapshot.push('');
    }

    // Other active orchestrations
    if (taskFiles.length > 1) {
      snapshot.push('## Other Active Orchestrations');
      snapshot.push('');
      for (let i = 1; i < taskFiles.length; i++) {
        const tf = taskFiles[i];
        const fm = tf.content.match(/feature:\s*(.+)/);
        snapshot.push('- `' + tf.name + '`: ' + (fm ? fm[1].trim() : 'Unknown') + ' (status: ' + tf.status + ')');
      }
      snapshot.push('');
    }

    snapshot.push('## End of Snapshot');
    snapshot.push('');

    // Write the snapshot file
    const snapshotPath = path.join(tasksDir, '_compact_snapshot.md');
    fs.writeFileSync(snapshotPath, snapshot.join('\n'), 'utf8');

    // Inform user via stderr (visible in verbose mode)
    process.stderr.write('[PreCompact] Orchestration snapshot saved: _compact_snapshot.md\n');
    process.stderr.write('[PreCompact] Feature: ' + featureName + ' | Progress: ' + completedUnits + '/' + totalUnits + ' units\n');
    process.stderr.write('[PreCompact] Orchestration file updated: ' + activeTask.name + '\n');

  } catch(e) {
    process.stderr.write('[PreCompact] Hook error: ' + e.message + '\n');
    // Non-blocking: exit 0 so compaction proceeds
  }
NODESCRIPT

node "$SCRIPTFILE" "$TMPFILE"
rm -f "$SCRIPTFILE"

exit 0
