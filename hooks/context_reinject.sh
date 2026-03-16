#!/usr/bin/bash
# Hook: Context Re-injection After Compaction
# Event: SessionStart (compact)
# Purpose: Re-injects critical project context after context window compaction.
#          If an orchestration snapshot exists (_compact_snapshot.md), injects full
#          orchestration state with explicit resumption instructions and forces
#          Claude to read task progress before proceeding with any work.
#
# Integration:
#   - Reads: .claude/tasks/_compact_snapshot.md (written by orchestration_snapshot.sh)
#   - Reads: .claude/tasks/*.md (active orchestration files)
#   - Reads: TASKS.md (manual session handoff tasks)
#
# Output: stdout text is added as context to Claude's conversation after compaction.

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
    const tasksDir = path.join(cwd, '.claude', 'tasks');
    const snapshotPath = path.join(tasksDir, '_compact_snapshot.md');

    const lines = [];
    lines.push('=== POST-COMPACTION CONTEXT RE-INJECTION ===');
    lines.push('');
    lines.push('PROJECT REMINDERS:');
    lines.push('- Repo details/guidelines: CLAUDE.md');
    lines.push('- Documentation guidance: CONDUCTOR.md');
    lines.push('- Use service layer pattern (no business logic in routes)');
    lines.push('- Use repository pattern (no direct DB queries in routes)');
    lines.push('- Never commit .env files, never set ALLOWED_HOSTS=["*"]');
    lines.push('- Update JOURNAL.md after significant changes');
    lines.push('');

    // Re-inject active tasks from TASKS.md
    const tasksFile = path.join(cwd, 'TASKS.md');
    if (fs.existsSync(tasksFile)) {
      const tasksContent = fs.readFileSync(tasksFile, 'utf8');
      const activeLines = tasksContent.split('\n')
        .filter(l => /IN_PROGRESS|BLOCKED/i.test(l))
        .slice(0, 5);
      if (activeLines.length > 0) {
        lines.push('ACTIVE TASKS (from TASKS.md):');
        for (const al of activeLines) lines.push('  - ' + al.trim());
        lines.push('');
      }
    }

    // =====================================================
    // ORCHESTRATION RESUMPTION - HIGHEST PRIORITY
    // =====================================================

    let orchestrationActive = false;
    let orchestrationFile = '';

    // Check for compaction snapshot first (written by orchestration_snapshot.sh PreCompact hook)
    if (fs.existsSync(snapshotPath)) {
      const snapshot = fs.readFileSync(snapshotPath, 'utf8');

      orchestrationActive = true;

      lines.push('');
      lines.push('╔══════════════════════════════════════════════════════════════╗');
      lines.push('║  ORCHESTRATION IN PROGRESS - AUTOMATIC RESUME REQUIRED      ║');
      lines.push('╚══════════════════════════════════════════════════════════════╝');
      lines.push('');

      // Extract feature name from snapshot frontmatter
      const featureMatch = snapshot.match(/feature:\s*(.+)/);
      const featureName = featureMatch ? featureMatch[1].trim() : 'Unknown';

      // Extract source file from snapshot
      const sourceMatch = snapshot.match(/source_file:\s*(.+)/);
      const sourceFile = sourceMatch ? sourceMatch[1].trim() : '';
      orchestrationFile = sourceFile;

      // Extract plan source
      const planMatch = snapshot.match(/plan_source:\s*(.+)/);
      const planSource = planMatch ? planMatch[1].trim() : '';

      // Extract unit counts
      const totalMatch = snapshot.match(/total_units:\s*(\d+)/);
      const completedMatch = snapshot.match(/completed_units:\s*(\d+)/);
      const totalUnits = totalMatch ? totalMatch[1] : '?';
      const completedUnits = completedMatch ? completedMatch[1] : '?';

      lines.push('Feature: ' + featureName);
      lines.push('Progress: ' + completedUnits + '/' + totalUnits + ' units completed');
      if (sourceFile) lines.push('Orchestration File: .claude/tasks/' + sourceFile);
      if (planSource) lines.push('Plan Source: ' + planSource);
      lines.push('');

      // Extract and inject the resume instructions section
      const resumeMatch = snapshot.match(/## RESUME INSTRUCTIONS[\s\S]*?(?=\n## )/);
      if (resumeMatch) {
        lines.push(resumeMatch[0].trim());
        lines.push('');
      }

      // Extract progress summary
      const progressMatch = snapshot.match(/## Progress Summary[\s\S]*?(?=\n## )/);
      if (progressMatch) {
        lines.push(progressMatch[0].trim());
        lines.push('');
      }

      // Extract wave breakdown
      const waveMatch = snapshot.match(/## Wave Breakdown[\s\S]*?(?=\n## )/);
      if (waveMatch) {
        lines.push(waveMatch[0].trim());
        lines.push('');
      }

      // Extract active units
      const activeMatch = snapshot.match(/## Active Units[\s\S]*?(?=\n## )/);
      if (activeMatch) {
        lines.push(activeMatch[0].trim());
        lines.push('');
      }

      // Extract blocked units
      const blockedMatch = snapshot.match(/## Blocked Units[\s\S]*?(?=\n## )/);
      if (blockedMatch) {
        lines.push(blockedMatch[0].trim());
        lines.push('');
      }

      // Extract live task state
      const taskStateMatch = snapshot.match(/## Live Task State[\s\S]*?(?=\n## )/);
      if (taskStateMatch) {
        lines.push(taskStateMatch[0].trim());
        lines.push('');
      }

      // Extract recently dispatched sub-agents
      const agentsMatch = snapshot.match(/## Recently Dispatched Sub-Agents[\s\S]*?(?=\n## )/);
      if (agentsMatch) {
        lines.push(agentsMatch[0].trim());
        lines.push('');
      }

      // Extract last progress report
      const reportMatch = snapshot.match(/## Last Progress Report[\s\S]*?(?=\n## |$)/);
      if (reportMatch) {
        lines.push(reportMatch[0].trim());
        lines.push('');
      }

      // Extract other active orchestrations
      const otherMatch = snapshot.match(/## Other Active Orchestrations[\s\S]*?(?=\n## |$)/);
      if (otherMatch) {
        lines.push(otherMatch[0].trim());
        lines.push('');
      }

    } else if (fs.existsSync(tasksDir)) {
      // No snapshot but check for active orchestration files directly
      try {
        const files = fs.readdirSync(tasksDir)
          .filter(f => f.endsWith('.md') && f !== 'README.md' && !f.startsWith('_'))
          .map(f => ({ name: f, mtime: fs.statSync(path.join(tasksDir, f)).mtimeMs }))
          .sort((a, b) => b.mtime - a.mtime);

        if (files.length > 0) {
          const latestFile = files[0].name;
          const content = fs.readFileSync(path.join(tasksDir, latestFile), 'utf8');

          const statusMatch = content.match(/status:\s*(\w+)/);
          const status = statusMatch ? statusMatch[1] : '';

          if (status && status !== 'completed') {
            orchestrationActive = true;
            orchestrationFile = latestFile;

            const featureMatch = content.match(/feature:\s*(.+)/);
            const featureName = featureMatch ? featureMatch[1].trim() : 'Unknown';

            const completedCount = (content.match(/\| completed/gi) || []).length;
            const inProgressCount = (content.match(/\| in_progress/gi) || []).length;
            const pendingCount = (content.match(/\| pending/gi) || []).length;
            const blockedCount = (content.match(/\| blocked/gi) || []).length;

            lines.push('');
            lines.push('╔══════════════════════════════════════════════════════════════╗');
            lines.push('║  ORCHESTRATION DETECTED (no snapshot) - RESUME REQUIRED     ║');
            lines.push('╚══════════════════════════════════════════════════════════════╝');
            lines.push('');
            lines.push('Feature: ' + featureName);
            lines.push('File: .claude/tasks/' + latestFile);
            lines.push('Status: ' + status);
            lines.push('Units: ' + completedCount + ' completed, ' + inProgressCount + ' in-progress, ' + pendingCount + ' pending, ' + blockedCount + ' blocked');
            lines.push('');
          }
        }
      } catch(e) {}
    }

    // =====================================================
    // MANDATORY NEXT STEPS - Always inject when orchestration is active
    // =====================================================

    if (orchestrationActive) {
      lines.push('');
      lines.push('╔══════════════════════════════════════════════════════════════╗');
      lines.push('║  MANDATORY: READ TASK PROGRESS BEFORE ANY OTHER ACTION      ║');
      lines.push('╚══════════════════════════════════════════════════════════════╝');
      lines.push('');
      lines.push('Context was just compacted. You MUST perform these steps IMMEDIATELY');
      lines.push('and IN ORDER before doing anything else:');
      lines.push('');
      lines.push('  STEP 1: Read the orchestration file');
      lines.push('    → Use Read tool on: .claude/tasks/' + orchestrationFile);
      lines.push('    → Understand: which wave is active, which units are done/pending/blocked');
      lines.push('');
      lines.push('  STEP 2: Get live task system state');
      lines.push('    → Run TaskList to see all tasks and their current status');
      lines.push('    → Cross-reference with orchestration file to determine true state');
      lines.push('');
      lines.push('  STEP 3: Identify ready units');
      lines.push('    → Find units that are: pending AND all dependencies satisfied');
      lines.push('    → Check if any in_progress units need to be checked on or re-dispatched');
      lines.push('');
      lines.push('  STEP 4: Resume execution');
      lines.push('    → Dispatch ALL ready units in parallel using the Task tool');
      lines.push('    → Use appropriate sub-agent types for each unit');
      lines.push('    → Continue wave-based execution until all units complete');
      lines.push('');
      lines.push('  STEP 5: Update orchestration file');
      lines.push('    → After dispatching, update .claude/tasks/' + orchestrationFile);
      lines.push('    → Move units from pending → in_progress as they are dispatched');
      lines.push('');
      lines.push('DO NOT ask the user what to do next.');
      lines.push('DO NOT start new unrelated work.');
      lines.push('DO NOT skip reading the orchestration file.');
      lines.push('The orchestration was interrupted by compaction and MUST resume automatically.');
      lines.push('');
    }

    lines.push('=== END RE-INJECTION ===');
    console.log(lines.join('\n'));

  } catch(e) {
    // Fallback: output minimal context
    console.log('=== POST-COMPACTION CONTEXT RE-INJECTION ===');
    console.log('Check CLAUDE.md for full project context.');
    console.log('IMPORTANT: Check .claude/tasks/ for any active orchestration that needs resuming.');
    console.log('Run TaskList to see current task state.');
    console.log('=== END RE-INJECTION ===');
  }
NODESCRIPT

node "$SCRIPTFILE" "$TMPFILE"
rm -f "$SCRIPTFILE"

exit 0
