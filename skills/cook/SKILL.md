---
name: cook
description: "ALWAYS activate this skill before implementing EVERY feature, plan, or fix."
---

# Cook - Smart Feature Implementation

End-to-end implementation with automatic workflow detection.

**Principles:** YAGNI, KISS, DRY | Token efficiency | Concise reports

## Usage

```
/cook <natural language task OR plan path>
```

## Smart Intent Detection

Automatically routes to the appropriate workflow:

| Input Pattern | Route | Behavior |
|---------------|-------|----------|
| Contains "auto" + "fast", "quick", "trust me" | `/cook:auto:fast` | Scout→plan→implement (no research, no review) |
| Contains "auto" + "parallel" OR lists 3+ features | `/cook:auto:parallel` | Parallel planning & multi-agent execution |
| Contains "auto", "trust me" | `/cook:auto` | Plan→implement→test→review→commit (auto-approve) |
| Path to `plan.md` or `phase-*.md` | code mode | Execute existing plan directly |
| Default | interactive mode | Full workflow with user review gates |

See `references/intent-detection.md` for detection logic.

## Available Sub-Commands

| Command | Description |
|---------|-------------|
| `/cook:auto` | Auto-approve: plan→implement→test→review→commit |
| `/cook:auto:fast` | Fastest: scout→plan:fast→implement→commit (skip research & review) |
| `/cook:auto:parallel` | Parallel: plan:parallel→multi-agent implementation→test→review→docs |

## Interactive Workflow (Default)

```
[Research] → [Review] → [Plan] → [Review] → [Implement] → [Review] → [Test] → [Review] → [Finalize]
```

Stops at `[Review]` gates for human approval before each major step.

**Claude Tasks:** Use `TaskCreate`, `TaskUpdate`, `TaskGet` and `TaskList` during implementation.

## Step Output Format

```
✓ Step [N]: [Brief status] - [Key metrics]
```

## Blocking Gates (Interactive Mode)

Human review required at these checkpoints:
- **Post-Research:** Review findings before planning
- **Post-Plan:** Approve plan before implementation
- **Post-Implementation:** Approve code before testing
- **Post-Testing:** 100% pass + approve before finalize

**Always enforced (all modes):**
- **Testing:** 100% pass required
- **Code Review:** User approval OR auto-approve (score≥9.5, 0 critical)
- **Finalize (MANDATORY - never skip):**
  1. Update plan/phase status to complete directly (edit plan.md + phase files)
  2. `documentation-generator` subagent → update `./docs` if changes warrant
  3. `TaskUpdate` → mark all Claude Tasks complete
  4. Ask user if they want to commit via `git-manager` subagent

## Required Subagents (MANDATORY)

| Phase | Subagent | Requirement |
|-------|----------|-------------|
| Research | WebSearch/WebFetch | Skip in auto:fast and code mode |
| Codebase Search | Explore subagents with Glob/Grep | Skip in code mode |
| Plan | `implementation-planner` | Skip in code mode |
| UI Work | `senior-frontend-engineer` | If frontend work |
| Testing | `integration-test-executor`, `debugger` | **MUST** spawn |
| Review | `code-reviewer` | **MUST** spawn |
| Finalize | `documentation-generator`, `git-manager` | **MUST** spawn both + update plan status |

**CRITICAL ENFORCEMENT:**
- Testing, Review, and Finalize **MUST** use Task tool to spawn subagents
- DO NOT implement testing, review, or finalization yourself - DELEGATE
- If workflow ends with 0 Task tool calls, it is INCOMPLETE

## References

- `references/intent-detection.md` - Detection rules and routing logic
- `references/workflow-steps.md` - Detailed step definitions
- `references/review-cycle.md` - Interactive and auto review processes
- `references/subagent-patterns.md` - Subagent invocation patterns
