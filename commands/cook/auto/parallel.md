---
description: Plan parallel phases & execute with engineer agents in parallel
argument-hint: [tasks]
---

Think harder to implement in parallel: <tasks>$ARGUMENTS</tasks>

**IMPORTANT:** Activate needed skills. Ensure token efficiency. Sacrifice grammar for concision.

## Workflow

### 1. Research (Optional)
- Use WebSearch/WebFetch if tasks are complex (max 5 searches)
- Use Explore subagents with Glob/Grep to search codebase
- Keep reports ≤150 lines

### 2. Parallel Planning
- Trigger `/plan:parallel <detailed-instruction>`
- Wait for plan with dependency graph, execution strategy, file ownership matrix

### 3. Parallel Implementation
- Read `plan.md` for dependency graph
- Launch multiple `senior-backend-engineer` / `senior-frontend-engineer` agents in PARALLEL for concurrent phases
  - Example: "Phases 1-3 parallel" → launch 3 agents simultaneously
  - Pass phase file path: `{plan-dir}/phase-XX-*.md`
  - Include environment info
- Wait for all parallel phases to complete before dependent phases
- Sequential phases: launch one agent at a time

### 4. Testing
- Use `integration-test-executor` subagent for full test suite
- NO fake data/mocks/cheats
- If fail: use `debugger` subagent, fix, repeat

### 5. Code Review
- Use `code-reviewer` subagent for all changes
- If critical issues: fix, retest

### 6. Documentation & Plan Updates
- If approved: update plan/phase status directly + spawn `documentation-generator` subagent
- Update plan files, docs, roadmap
- If rejected: fix and repeat

### 7. Final Report
- Summary of all parallel phases
- Guide to get started
- Ask to commit (use `git-manager` subagent if yes)
