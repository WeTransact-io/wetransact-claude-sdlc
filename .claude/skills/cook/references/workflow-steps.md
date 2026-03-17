# Workflow Steps

The cook skill handles two internal modes: **interactive** (default) and **code** (plan path).
Auto variants are handled by sub-commands: `/cook:auto`, `/cook:auto:fast`, `/cook:auto:parallel`.

## Step 0: Intent Detection & Setup

1. Parse input with `intent-detection.md` rules
2. If routed to sub-command → delegate and stop
3. If mode=code: detect plan path, set active plan
4. Use `TaskCreate` to create workflow step tasks (with dependencies if complex)

**Output:** `✓ Step 0: Mode [interactive|code] - [detection reason]`

## Step 1: Research (skip in code mode)

- Use WebSearch/WebFetch for research (max 5 searches)
- Use Explore subagents with Glob/Grep for codebase search
- Keep reports ≤150 lines

**Output:** `✓ Step 1: Research complete - [N] reports gathered`

### [Review Gate 1] Post-Research
- Present research summary to user
- Use `AskUserQuestion`: "Proceed to planning?" / "Request more research" / "Abort"

## Step 2: Planning (skip in code mode)

- Use `implementation-planner` agent with research context
- Create `plan.md` + `phase-XX-*.md` files

**Output:** `✓ Step 2: Plan created - [N] phases`

### [Review Gate 2] Post-Plan
- Present plan overview with phases
- Use `AskUserQuestion`: "Validate" / "Approve" / "Abort" / "Other"
  - "Validate": run `/plan:validate` slash command
  - "Approve": continue to implementation
  - "Abort": stop the workflow
  - "Other": revise based on feedback

## Step 3: Implementation

**IMPORTANT:**
1. `TaskList` first — check for existing tasks (hydrated by planning skill in same session)
2. If tasks exist → pick them up, skip re-creation
3. If no tasks → read plan phases, `TaskCreate` for each unchecked `[ ]` item with priority order
4. Tasks can be blocked by other tasks via `addBlockedBy`

- Use `TaskUpdate` to mark tasks as `in_progress` immediately
- Execute phase tasks sequentially (Step 3.1, 3.2, etc.)
- Use `senior-frontend-engineer` for frontend work
- Run type checking after each file

**Output:** `✓ Step 3: Implemented [N] files - [X/Y] tasks complete`

### [Review Gate 3] Post-Implementation
- Present implementation summary (files changed, key changes)
- Use `AskUserQuestion`: "Proceed to testing?" / "Request changes" / "Abort"

## Step 4: Testing

- Write tests: happy path, edge cases, errors
- **MUST** spawn test executor subagent (see `subagent-patterns.md`)
- Use `e2e-test-executor` for UI/browser testing
- If failures: **MUST** spawn `debugger` subagent → fix → repeat
- **Forbidden:** fake mocks, commented tests, changed assertions

**Output:** `✓ Step 4: Tests [X/X passed] - test executor subagent invoked`

### [Review Gate 4] Post-Testing
- Present test results summary
- Use `AskUserQuestion`: "Proceed to code review?" / "Request test fixes" / "Abort"

## Step 5: Code Review

- **MUST** spawn `code-reviewer` subagent (see `subagent-patterns.md`)
- **DO NOT** review code yourself - delegate to subagent
- Interactive cycle (max 3): see `review-cycle.md`
- Requires user approval

**Output:** `✓ Step 5: Review [score]/10 - [Approved] - code-reviewer subagent invoked`

## Step 6: Finalize (MANDATORY - never skip)

1. Update plan/phase status to complete directly (edit plan.md + phase files)
2. **MUST** spawn `documentation-generator` subagent → update docs
3. Use `TaskUpdate` to mark Claude Tasks complete immediately
4. Onboarding check (API keys, env vars)
5. **MUST** spawn `git-manager` subagent → commit

**CRITICAL:** Step 6 is INCOMPLETE without updating plan status + spawning both subagents.

**Output:** `✓ Step 6: Finalized - 3 subagents invoked - Status updated - Committed`

## Flow Summary

```
interactive: 0 → 1 → [R] → 2 → [R] → 3 → [R] → 4 → [R] → 5(user) → 6
code:        0 → skip → skip → 3 → [R] → 4 → [R] → 5(user) → 6
```

## Critical Rules

- **MANDATORY SUBAGENT DELEGATION:** Steps 4, 5, 6 MUST spawn subagents via Task tool
  - Step 4: `integration-test-executor` or `e2e-test-executor` (and `debugger` if failures)
  - Step 5: `code-reviewer`
  - Step 6: `documentation-generator`, `git-manager` + direct plan status update
- Use `TaskCreate`/`TaskUpdate` for progress tracking
- All step outputs follow format: `✓ Step [N]: [status] - [metrics]`
- **VALIDATION:** If Task tool calls = 0 at end of workflow, the workflow is INCOMPLETE
