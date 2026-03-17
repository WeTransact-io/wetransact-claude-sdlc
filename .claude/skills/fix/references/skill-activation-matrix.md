# Skill Activation Matrix

When to activate each skill and tool during fixing workflows.

## Always Activate

| Skill/Tool | Reason |
|------------|--------|
| `debug` | Core to all fix workflows - find root cause first |

## Task Orchestration (Moderate+ Only)

| Tool | Activate When |
|------|---------------|
| `TaskCreate` | After complexity assessment, create all phase tasks upfront |
| `TaskUpdate` | At start/completion of each phase |
| `TaskList` | Check available unblocked work, coordinate parallel agents |
| `TaskGet` | Retrieve full task details before starting work |

Skip Tasks for Quick workflow (< 3 steps). See `references/task-orchestration.md`.

## Subagent Usage

| Subagent | Activate When |
|----------|---------------|
| `debugger` | Root cause unclear, need deep investigation |
| `Explore` (parallel) | Scout multiple areas simultaneously |
| `Bash` (parallel) | Verify implementation (typecheck, lint, build) |
| WebSearch/WebFetch | External docs needed, latest best practices |
| `implementation-planner` | Complex fix needs breakdown, multiple phases |
| `integration-test-executor` | After implementation, verify fix works |
| `code-reviewer` | After fix, verify quality and security |
| `git-manager` | After approval, commit changes |
| `documentation-generator` | API/behavior changes need doc updates |
| Direct plan status update | Major fix impacts roadmap/plan status |
| `senior-backend-engineer` + `senior-frontend-engineer` | Parallel independent issues (spawn both in parallel per issue) |

## Parallel Patterns

See `references/parallel-exploration.md` for detailed patterns.

| When | Parallel Strategy |
|------|-------------------|
| Root cause unclear | 2-3 `Explore` agents on different areas |
| Multi-module fix | `Explore` each module in parallel |
| After implementation | `Bash` agents: typecheck + lint + build |
| Before commit | `Bash` agents: test + build + lint |
| 2+ independent issues | Task trees + `senior-backend-engineer` + `senior-frontend-engineer` agents per issue |

## Workflow → Skills Map

| Workflow | Skills Activated |
|----------|------------------|
| Quick | `debug`, `code-reviewer`, parallel `Bash` verification |
| Standard | Above + Tasks, `integration-test-executor`, parallel `Explore` |
| Deep | All above + WebSearch/WebFetch, `implementation-planner` |
| Parallel | Per-issue Task trees + `senior-backend-engineer` + `senior-frontend-engineer` agents + coordination via `TaskList` |

## Detection Triggers

| Keyword/Pattern | Skill to Consider |
|-----------------|-------------------|
| "which approach", "options" | Use `AskUserQuestion` to discuss trade-offs |
| "latest docs", "best practice" | WebSearch/WebFetch |
