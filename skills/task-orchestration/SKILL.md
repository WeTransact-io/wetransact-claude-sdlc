---
name: task-orchestration
description: Pure orchestration for parallel implementation workflows. Activates when an implementation plan exists and multiple work units need coordination. Only tracks state, manages dependencies, and dispatches work to sub-agents. Does not perform any validation or testing - sub-agents own their work end-to-end.
---

# Task Orchestration

This skill enables coordination of parallel implementation workflows by managing state, dependencies, and sub-agent dispatch.

## When to Use

- An implementation plan exists with multiple work units
- Work units have dependencies requiring sequenced execution
- Parallel execution across specialized sub-agents would improve efficiency

## Scope

Orchestration **only** handles:
- Parsing plans into work units
- Tracking execution state via the task system
- Managing dependencies between units
- Dispatching work to appropriate sub-agents

Orchestration **does not** handle:
- Implementation of any work unit
- Validation or testing of deliverables
- Contract verification

Sub-agents own their work end-to-end.

## Orchestration Flow

```
Parse Plan → Initialize Tasks → Dispatch Wave 0
                                      ↓
                               ┌─────────────┐
                               │    LOOP     │
                               └──────┬──────┘
                                      ↓
                              Await Sub-agent Result
                                      ↓
                              Mark Unit Complete
                                      ↓
                              Dispatch Ready Units
                                      ↓
                              All done? → No → LOOP
                                      ↓ Yes
                              Report Complete
```

## Plan Ingestion

Locate implementation plans in:
- `.claude/plans/*.md`
- `*-spec.md`, `*-plan.md` files
- `.claude/output/specs/*/*.md`
- Technical specifications provided in conversation 

Extract from the plan:
- Work units with full descriptions
- Dependencies between units
- Wave assignments (units with no dependencies = Wave 0)
- Recommended sub-agent type per unit

Initialize the task system:

```
For each unit:

TaskCreate:
  subject: "[Wave N] UNIT-ID: Name"
  description: Full unit specification from plan
  activeForm: "Implementing UNIT-ID"
  metadata: { wave, unitId, agentType }

TaskUpdate:
  addBlockedBy: [IDs of units this depends on]
```

## Dispatch Rules

A unit is ready for dispatch when:
- Status is `pending`
- `blockedBy` list is empty

Dispatch process:
1. Mark unit `in_progress` via `TaskUpdate`
2. Spawn sub-agent via `Task` tool with unit description
3. Dispatch ALL ready units simultaneously using parallel `Task` calls

## Sub-Agent Selection

### Planning & Specification Agents

| Unit Type | Sub-Agent | Model |
|-----------|-----------|-------|
| Product Brief Validation | `product-brief-analyst` | Opus |
| Technical Specification | `tech-spec-architect` | Opus |
| Implementation Planning | `implementation-planner` | Opus |
| Contract/Interface Generation | `contract-generator` | Sonnet |

### Implementation Agents

| Unit Type | Sub-Agent | Model |
|-----------|-----------|-------|
| Database Schema | `senior-backend-engineer` | Sonnet |
| Database Migrations | `database-migration-specialist` | Sonnet |
| API/Services | `senior-backend-engineer` | Sonnet |
| Business Logic | `senior-backend-engineer` | Sonnet |
| Authentication/Authorization | `senior-backend-engineer` | Sonnet |
| Caching Layer | `senior-backend-engineer` | Sonnet |
| Message Queues | `senior-backend-engineer` | Sonnet |
| UI Components | `senior-frontend-engineer` | Sonnet |
| State Management | `senior-frontend-engineer` | Sonnet |
| API Integration (Frontend) | `senior-frontend-engineer` | Sonnet |
| Styling/Theming | `senior-frontend-engineer` | Sonnet |

### Infrastructure Agents

| Unit Type | Sub-Agent | Model |
|-----------|-----------|-------|
| Containerization/Docker | `devops-engineer` | Sonnet |
| CI/CD Pipeline | `devops-engineer` | Sonnet |
| Infrastructure as Code | `devops-engineer` | Sonnet |
| Cloud Deployment | `devops-engineer` | Sonnet |
| Secrets Management | `devops-engineer` | Sonnet |

### Quality Assurance Agents

| Unit Type | Sub-Agent | Model |
|-----------|-----------|-------|
| Test Specifications | `test-spec-generator` | Opus |
| Integration Tests | `integration-test-executor` | Sonnet |
| E2E Tests | `e2e-test-executor` | Sonnet |
| Security Tests | `security-test-executor` | Sonnet |
| Performance Tests | `performance-test-executor` | Sonnet |
| Accessibility Tests | `accessibility-test-executor` | Sonnet |
| Code Review | `code-reviewer` | Opus |

### Documentation & Observability Agents

| Unit Type | Sub-Agent | Model |
|-----------|-----------|-------|
| API Documentation | `documentation-generator` | Sonnet |
| User Guides | `documentation-generator` | Sonnet |
| Architecture Decision Records | `documentation-generator` | Sonnet |
| Deployment Guides | `documentation-generator` | Sonnet |
| Logging Infrastructure | `observability-engineer` | Sonnet |
| Metrics/Dashboards | `observability-engineer` | Sonnet |
| Alerting Rules | `observability-engineer` | Sonnet |
| Distributed Tracing | `observability-engineer` | Sonnet |

### Refinement Agents

| Unit Type | Sub-Agent | Model |
|-----------|-----------|-------|
| Code Simplification | `code-simplifier` | Opus |

## Dispatch Prompt Template

```
Implement: [Unit Name]

[Full unit description from plan]

Context files: [relevant files if specified in plan]

Complete this unit fully.
```

## Completion Handling

When a sub-agent returns:

1. `TaskUpdate` with `status: completed`
2. `TaskList` to find units now unblocked
3. Dispatch all newly ready units in parallel
4. Brief progress update

## State Management

### Task System Integration

Use Claude Code's native task tools:

| Tool | Purpose |
|------|---------|
| `TaskCreate` | Initialize work units |
| `TaskUpdate` | Update status, set dependencies |
| `TaskList` | View all units and state |
| `TaskGet` | Get full unit details |

Task metadata:
```json
{
  "wave": 0,
  "unitId": "UNIT-01",
  "agentType": "senior-backend-engineer"
}
```

### Task File Management

**IMPORTANT**: Write open (non-completed) tasks to `.claude/tasks/<feature-name>-<timestamp>.md`

#### File Naming Convention

```
<feature-name>-<timestamp>.md

Examples:
- workspace-sync-2026-02-09-14-30.md
- user-authentication-2026-02-09-10-15.md
- payment-integration-2026-02-09-16-45.md
```

#### When to Create Task File

Create a new task file at **orchestration start**:

```
1. Extract feature name from plan file
2. Generate timestamp: YYYY-MM-DD-HH-MM
3. Create file: .claude/tasks/<feature-name>-<timestamp>.md
4. Write initial task structure
```

#### Task File Structure

```markdown
---
feature: <feature-name>
started: <timestamp>
status: in_progress | completed | blocked
total_units: <N>
completed_units: <M>
---

# Task: <Feature Name>

**Description**: <Brief feature description from plan>
**Plan Source**: `.claude/plans/<plan-file>.md`
**Started**: <timestamp>
**Status**: <status>

## Progress Summary

- **Total Units**: <N>
- **Completed**: <M> (<percentage>%)
- **In Progress**: <P>
- **Blocked**: <B>
- **Pending**: <Q>

## Wave Breakdown

### Wave 0: Foundation
- [ ] **UNIT-01**: <name> → `<agent-type>` (status: pending | in_progress | completed)
- [x] **UNIT-02**: <name> → `<agent-type>` (status: completed)

### Wave 1: Core Implementation
- [ ] **UNIT-03**: <name> → `<agent-type>` (blocked by: UNIT-01)
- [ ] **UNIT-04**: <name> → `<agent-type>` (in_progress)

### Wave 2: Integration
...

## Active Units

| Unit ID | Name | Agent | Status | Started | Completed |
|---------|------|-------|--------|---------|-----------|
| UNIT-04 | API scaffolding | senior-backend-engineer | in_progress | 2026-02-09 14:35 | - |

## Completed Units

| Unit ID | Name | Agent | Status | Started | Completed |
|---------|------|-------|--------|---------|-----------|
| UNIT-02 | Database migration | database-migration-specialist | completed | 2026-02-09 14:30 | 2026-02-09 14:33 |

## Blocked Units

| Unit ID | Name | Blocked By | Reason |
|---------|------|------------|--------|
| UNIT-03 | Data access layer | UNIT-01 | Awaiting schema completion |

## Notes

- Any important observations
- Issues encountered
- Decisions made during orchestration
```

#### Task File Updates

Update the task file after each wave transition:

```
1. Mark completed units with [x] in wave breakdown
2. Update Active Units table
3. Move completed units to Completed Units table
4. Update Progress Summary percentages
5. Add notes about any issues or decisions
```

#### Task File Completion

When all units are completed:

1. Update frontmatter `status: completed`
2. Add final completion timestamp
3. Add summary of outcomes
4. Keep file in `.claude/tasks/` for historical record

**Note**: Completed task files remain in `.claude/tasks/` as an audit trail. They are NOT moved to archive.

## Progress Reporting

### Console Updates

Report status after wave transitions in the conversation:

```
## Orchestration Progress

Wave: [N] of [M]
Completed: [X] / [Y] units

Active:
- UNIT-01 → senior-backend-engineer
- UNIT-02 → senior-frontend-engineer

Ready to Dispatch:
- UNIT-03, UNIT-04

Waiting:
- UNIT-05 (blocked by UNIT-01)
```

### Task File Updates

**CRITICAL**: After each wave transition, update `.claude/tasks/<feature-name>-<timestamp>.md`:

1. Update Progress Summary section with latest counts
2. Mark completed units with [x] in Wave Breakdown
3. Update Active Units table with in-progress units
4. Move completed units to Completed Units table
5. Update Blocked Units table if dependencies change

This ensures task state is preserved between sessions and provides an audit trail.

## Key Principles

1. **Pure orchestration** - Track state and dispatch only
2. **Maximum parallelism** - Dispatch all ready units simultaneously
3. **Trust sub-agents** - Mark complete when they return
4. **Transparent progress** - Report after wave transitions
5. **Simple handoff** - Clear context, then let sub-agents work
6. **Feedback loops** - Route test failures back to engineers until resolved

---

## Test-Fix Feedback Loop

When testing agents discover failures, orchestration routes issues back to the appropriate engineer for fixes. This cycle continues until all tests pass.

### Feedback Loop Flow

```
                    ┌─────────────────────────────────────────┐
                    │         Test Agents Execute             │
                    │  (integration, e2e, security, perf,     │
                    │   accessibility - all in parallel)       │
                    └─────────────────┬───────────────────────┘
                                      │
                                      ▼
                    ┌─────────────────────────────────────────┐
                    │         Analyze Results                  │
                    └─────────────────┬───────────────────────┘
                                      │
                    ┌─────────────────┴───────────────────┐
                    │                                     │
               All Pass                              Failures Found
                    │                                     │
                    ▼                                     ▼
           Continue to next               ┌───────────────────────────┐
           phase (docs/deploy)            │   Classify Failures       │
                                          │   by responsible agent    │
                                          └─────────────┬─────────────┘
                                                        │
                                          ┌─────────────┴─────────────┐
                                          │                           │
                                    Backend Issues            Frontend Issues
                                          │                           │
                                          ▼                           ▼
                                  ┌───────────────┐          ┌───────────────┐
                                  │ Route to      │          │ Route to      │
                                  │ senior-       │          │ senior-       │
                                  │ backend-eng   │          │ frontend-eng  │
                                  └───────┬───────┘          └───────┬───────┘
                                          │                           │
                                          └───────────┬───────────────┘
                                                      │
                                                      ▼
                                          ┌───────────────────────────┐
                                          │   Engineer Applies Fix    │
                                          └─────────────┬─────────────┘
                                                        │
                                                        ▼
                                          ┌───────────────────────────┐
                                          │   Re-run Failed Tests     │
                                          │   (only failed, not all)  │
                                          └─────────────┬─────────────┘
                                                        │
                                                        └────────► Loop back
```

### Failure Classification & Routing

| Test Agent | Failure Type | Route To |
|------------|--------------|----------|
| `integration-test-executor` | API contract violations | `senior-backend-engineer` |
| `integration-test-executor` | Database errors | `database-migration-specialist` |
| `integration-test-executor` | Cache issues | `senior-backend-engineer` |
| `e2e-test-executor` | UI/interaction bugs | `senior-frontend-engineer` |
| `e2e-test-executor` | API call failures | `senior-backend-engineer` |
| `security-test-executor` | Auth/authz issues | `senior-backend-engineer` |
| `security-test-executor` | Injection flaws | `senior-backend-engineer` |
| `security-test-executor` | Dependency vulns | `devops-engineer` |
| `performance-test-executor` | Latency issues | `senior-backend-engineer` |
| `performance-test-executor` | Resource issues | `devops-engineer` |
| `accessibility-test-executor` | WCAG violations | `senior-frontend-engineer` |

### Fix Request Template

When routing a failure to an engineer:

```markdown
## Fix Request

**Source:** [test-agent-name]
**Test Type:** [Integration | E2E | Security | Performance | Accessibility]
**Iteration:** [1-5]

### Failure Summary

| Test | File | Error |
|------|------|-------|
| [test_name] | [file:line] | [brief error] |

### Detailed Analysis

#### Failure 1: [test_name]

**Error:**
```
[Full error message]
```

**Root Cause Analysis:**
[Analysis of why this failed]

**Affected Files:**
- `path/to/file1.ext`
- `path/to/file2.ext`

**Suggested Fix:**
[Concrete suggestion for fixing]

---

**Instructions:**
1. Apply fixes to affected files
2. Run related unit tests locally
3. Signal completion when ready for re-test
```

### Fix Task Metadata

When creating fix tasks:

```json
{
  "type": "fix",
  "sourceTest": "e2e-test-executor",
  "failedTests": ["test_user_login", "test_password_reset"],
  "iteration": 1,
  "maxIterations": 5,
  "affectedFiles": ["src/auth/login.ts", "src/stores/auth.ts"]
}
```

### Re-test Protocol

After engineer signals fix completion:

1. **Targeted Re-test**: Only run previously failed tests
2. **Same Agent**: Use the test agent that found the failure
3. **Parallel Re-tests**: If multiple test types failed, re-run in parallel

```
TaskUpdate:
  taskId: [fix-task-id]
  status: completed
  metadata: { fixApplied: true, changedFiles: [...] }

Then dispatch:
  Task → [original-test-agent] → "Re-run failed tests: [test_names]"
```

### Safeguards

| Safeguard | Value | Action |
|-----------|-------|--------|
| Max iterations | 5 | Escalate to human review |
| Escalation threshold | 3 | Flag for human attention |
| Fix timeout | 30 min | Abort and report |
| New failures introduced | Any | Analyze regression, may revert |

### Escalation Protocol

After 3 failed fix attempts:

```markdown
## Escalation Required

**Test:** [test_name]
**Agent:** [engineer-agent]
**Iterations:** 3

### Fix History

| Iteration | Fix Applied | Result |
|-----------|-------------|--------|
| 1 | [description] | Still failing |
| 2 | [description] | Still failing |
| 3 | [description] | Still failing |

### Current State
- Error persists: [error]
- Files modified: [list]
- Tests affected: [list]

### Recommendation
[Human intervention needed because...]
```

### Consolidated Fix Requests

When multiple test agents find failures:

1. **Aggregate by responsible agent**
2. **Send single consolidated request**
3. **Track all failures in one task**

Example:
```
Backend failures from:
- integration-test-executor: 2 failures
- security-test-executor: 1 failure

→ Single request to senior-backend-engineer with all 3 failures
```

### Progress Reporting During Fix Loop

```markdown
## Fix Loop Progress

**Iteration:** 2 of 5
**Status:** Fixes applied, awaiting re-test

### Original Failures
| Test Agent | Count | Status |
|------------|-------|--------|
| integration-test-executor | 3 | 2 fixed, 1 pending |
| e2e-test-executor | 2 | 2 fixed |
| security-test-executor | 1 | 0 fixed |

### Active Fix Tasks
- FIX-001: senior-backend-engineer → API validation (re-testing)
- FIX-002: senior-frontend-engineer → Complete ✓

### Next Actions
- Await re-test results for FIX-001
- If pass: Continue to documentation phase
- If fail: Iteration 3 with updated analysis
```
