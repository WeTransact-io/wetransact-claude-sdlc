---
name: fix
description: "ALWAYS activate this skill before fixing ANY bug, error, test failure, CI/CD issue, type error, lint, log error, UI issue, code problem."
---

# Fixing

Unified skill for fixing issues of any complexity with intelligent routing.

## Arguments

- `--auto` - Activate autonomous mode (**default**)
- `--review` - Activate human-in-the-loop review mode
- `--quick` - Activate quick mode
- `--parallel` - Activate parallel mode: route to parallel `senior-backend-engineer` + `senior-frontend-engineer` agents per issue

## Workflow

### Step 0: Smart Routing (from issue keywords)

Before starting the fix workflow, check if a specialized sub-command should handle this:

| Issue Type | Keywords | Route To |
|------------|----------|----------|
| Existing plan | Markdown plan path provided | `/cook <path-to-plan>` |
| Type errors | type, typescript, tsc | `/fix:fast <description>` |
| CI/CD issues | github actions, pipeline, ci/cd, deployment | `/fix:ci <url-or-description>` |
| Test failures | test, spec, jest, vitest | `/fix:test <description>` |
| UI/UX issues | ui, ux, layout, style, visual, css | `/fix:test <description-with-frontend-context>` |
| Log analysis | logs, error logs, stack trace | Activate `debug` skill |
| Multiple independent | 2+ unrelated issues | `/fix:parallel <description>` |
| Complex/system-wide | architecture, refactor, multiple components | `/fix:hard <description>` |
| Simple/default | Small bug, single file, unclear | Continue with Step 1 below |

If no keywords match or issue is ambiguous, ask user for clarification or continue with the standard workflow.

### Step 1: Mode Selection

**First action:** If there is no "auto" keyword in the request, use `AskUserQuestion` to determine workflow mode:

| Option | Recommend When | Behavior |
|--------|----------------|----------|
| **Autonomous** (default) | Simple/moderate issues | Auto-approve if score >= 9.5 & 0 critical |
| **Human-in-the-loop Review** | Critical/production code | Pause for approval at each step |
| **Quick** | Type errors, lint, trivial bugs | Fast debug → fix → review cycle |

See `references/mode-selection.md` for AskUserQuestion format.

### Step 2: Debug

- Activate `debug` skill.
- Guess all possible root causes.
- Spawn multiple `Explore` subagents in parallel to verify each hypothesis.
- Create report with all findings for the next step.

### Step 3: Complexity Assessment & Task Orchestration

Classify before routing. See `references/complexity-assessment.md`.

| Level | Indicators | Workflow |
|-------|------------|----------|
| **Simple** | Single file, clear error, type/lint | `references/workflow-quick.md` |
| **Moderate** | Multi-file, root cause unclear | `references/workflow-standard.md` |
| **Complex** | System-wide, architecture impact | `references/workflow-deep.md` |
| **Parallel** | 2+ independent issues OR `--parallel` flag | Parallel `senior-backend-engineer` + `senior-frontend-engineer` agents |

**Task Orchestration (Moderate+ only):** After classifying, create native Claude Tasks for all phases upfront with dependencies. See `references/task-orchestration.md`.
- Skip for Quick workflow (< 3 steps, overhead exceeds benefit)
- Use `TaskCreate` with `addBlockedBy` for dependency chains
- Update via `TaskUpdate` as each phase completes
- For Parallel: create separate task trees per independent issue

### Step 4: Fix Implementation & Verification

- Implement fix per selected workflow, updating Tasks as phases complete.
- Spawn multiple `Explore` subagents to verify no regressions.
- Prevent future issues by adding comprehensive validation.

### Step 5: Finalize (MANDATORY - never skip)

1. Report summary: confidence score, changes, files
2. `documentation-generator` subagent → update `./docs` if changes warrant (NON-OPTIONAL)
3. `TaskUpdate` → mark ALL Claude Tasks `completed`
4. Ask user if they want to commit via `git-manager` subagent

---

## IMPORTANT: Skill/Subagent Activation Matrix

See `references/skill-activation-matrix.md` for complete matrix.

**Always activate:** `debug` (all workflows)
**Subagents:** `debugger`, `implementation-planner`, `code-reviewer`, `integration-test-executor`, `Bash`
**Parallel:** Multiple `Explore` agents for codebase search, `Bash` agents for verification

## Output Format

Unified step markers:
```
✓ Step 0: [Mode] selected - [Complexity] detected
✓ Step 1: Root cause identified - [summary]
✓ Step 2: Fix implemented - [N] files changed
✓ Step 3: Tests [X/X passed]
✓ Step 4: Review [score]/10 - [status]
✓ Step 5: Complete - [action taken]
```

## References

Load as needed:
- `references/mode-selection.md` - AskUserQuestion format for mode
- `references/complexity-assessment.md` - Classification criteria
- `references/task-orchestration.md` - Native Claude Task patterns for moderate+ workflows
- `references/workflow-quick.md` - Quick: debug → fix → review
- `references/workflow-standard.md` - Standard: full pipeline with Tasks
- `references/workflow-deep.md` - Deep: research + brainstorm + plan with Tasks
- `references/review-cycle.md` - Review logic (autonomous vs HITL)
- `references/skill-activation-matrix.md` - When to activate each skill
- `references/parallel-exploration.md` - Parallel Explore/Bash/Task coordination patterns

**Specialized Workflows:**
- `references/workflow-ci.md` - GitHub Actions/CI failures
- `references/workflow-logs.md` - Application log analysis
- `references/workflow-test.md` - Test suite failures
- `references/workflow-types.md` - TypeScript type errors
