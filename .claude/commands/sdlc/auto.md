---
description: Run full SDLC implementation fully automated (no human gates between phases)
argument-hint: <linear-url | brief-filename>
---

Think harder. You are the **SDLC Orchestrator** in **fully automated mode**. Drive the entire Software Development Lifecycle end-to-end without stopping between phases.

Read `.claude/SOFTWARE_DEVELOPMENT_LIFECYCLE.md` before starting. Follow all 10 phases sequentially.

**Mode: FULLY AUTOMATED** — Use `TaskCreate`/`TaskUpdate`/`TaskList` to track all phases. Only stop for critical blockers that cannot be auto-resolved.

## Input

<input>$ARGUMENTS</input>

## Task Setup

Create a master task list using `TaskCreate` for each SDLC phase:

```
Task 1:  "Resolve product brief"
Task 2:  "Phase 1 — Validate brief"
Task 3:  "Phase 2 — Create technical specifications"
Task 4:  "Phase 3 — Create implementation plans"
Task 5:  "Phase 4 — Generate interface contracts"
Task 6:  "Phase 5 — Create test specifications"
Task 7:  "Phase 6 — Orchestrated implementation"
Task 8:  "Phase 7 — Code review"
Task 9:  "Phase 8 — Execute tests"
Task 10: "Phase 9 — Documentation & observability"
Task 11: "Phase 10 — Refinement (conditional)"
Task 12: "Finalization"
```

Set dependencies: each task blocked by its predecessor. Tasks 5 and 6 can run in parallel (no mutual dependency).

Mark each task `in_progress` when starting, `completed` when done.

---

## Step 0: Resolve Brief

Determine the brief source from the input:

### If input matches a Linear URL (`linear.app`):
1. Extract the issue/project identifier from the URL.
2. Use `WebFetch` to retrieve the page content with prompt: "Extract the full issue or project description, acceptance criteria, requirements, and any linked documents. Return the complete brief content."
3. If WebFetch fails (auth required), **stop and ask user** to paste the issue description or export it to `.claude/output/briefs/analysis/<name>.md`.
4. Save the extracted brief to `.claude/output/briefs/analysis/<slug-from-title>.md`.

### If input is NOT a Linear URL:
1. Search for a matching file in `.claude/output/briefs/analysis/` using Glob.
   - Try exact match: `.claude/output/briefs/analysis/$ARGUMENTS`
   - Try partial match: `.claude/output/briefs/analysis/*$ARGUMENTS*`
2. If no match found, check if the input is a file path and read it directly.
3. If still no match, **stop and ask user** to provide the brief location.

Mark Task 1 complete. Proceed immediately.

---

## Phase 1: Validation

Spawn `product-brief-analyst` agent (Opus):
- Input: The raw product brief content
- Task: Validate completeness, identify ambiguities, extract implicit requirements
- Output: Save to `.claude/output/briefs/validated/<slug>-validated-brief.md`

**Auto-resolve:** If ambiguities found, document assumptions in the validated brief and proceed. Only stop if the brief is fundamentally incomplete (no clear product described).

Mark Task 2 complete. Log: `✓ Phase 1: Brief validated — [N] requirements, [M] assumptions`

---

## Phase 2: Technical Specification

Spawn `tech-spec-architect` agent (Opus):
- Input: Validated brief from Phase 1
- Task: Create technical specifications (frontend-spec, backend-spec, repo-structure)
- Output: Save to `.claude/output/specs/`

Mark Task 3 complete. Log: `✓ Phase 2: Specs created — [list of spec files]`

---

## Phase 3: Implementation Planning

Spawn in **parallel**:
1. `implementation-planner` agent → Input: frontend-spec.md → Output: frontend plan
2. `implementation-planner` agent → Input: backend-spec.md → Output: backend plan

Then spawn:
3. `devops-engineer` agent → Input: both specs → Output: infrastructure plan

Save all plans to `.claude/plans/{plan-dir}/` using naming from `## Naming` section in injected context.

Mark Task 4 complete. Log: `✓ Phase 3: Plans created — [N] work units, [M] waves`

---

## Phase 4 & 5: Contracts + Test Specs (parallel)

Spawn **in parallel**:
1. `contract-generator` agent → Generate interface contracts → Save to `.claude/output/contracts/`
2. `test-spec-generator` agent → Create test strategies → Save to `.claude/output/tests/specs/`

Mark Tasks 5 and 6 complete. Log: `✓ Phase 4+5: Contracts + test specs generated`

---

## Phase 6: Orchestrated Implementation

Activate `/task-orchestration` skill:
- Parse plans from `.claude/plans/{plan-dir}/`
- Create task graph with dependencies
- Dispatch waves of parallel work using appropriate engineer agents
- Monitor completion and dispatch subsequent waves

Mark Task 7 complete. Log: `✓ Phase 6: Implementation complete — [N] files, [M] waves`

---

## Phase 7: Code Review

Spawn `code-reviewer` agent (Opus):
- Input: All implemented code from Phase 6
- Task: Review quality, security, performance, architectural consistency
- Output: Save review report to `.claude/output/reviews/`

**Auto-fix loop:** If blockers/critical issues found:
1. Route to appropriate engineer agent with fix request
2. Re-run code review
3. Max 3 iterations — if still blocked, log issues and continue (do not stop)

Mark Task 8 complete. Log: `✓ Phase 7: Review [score] — [N] issues found, [M] fixed`

---

## Phase 8: Testing

Spawn **all test executors in parallel**:
1. `integration-test-executor` → API contracts, DB integration
2. `e2e-test-executor` → User flows, cross-browser
3. `security-test-executor` → SAST/DAST, OWASP Top 10
4. `performance-test-executor` → Load tests, latency
5. `accessibility-test-executor` → WCAG compliance

Save reports to `.claude/output/tests/reports/<type>/`

**Auto-fix loop:** If tests fail:
1. Classify failures (backend/frontend/infra/security)
2. Route to appropriate engineer agent with fix request
3. Re-run only failed tests
4. Max 5 attempts per test — after 3, log as unresolved and continue

Mark Task 9 complete. Log: `✓ Phase 8: Tests — [pass]/[total] passed, [N] unresolved`

---

## Phase 9: Documentation & Observability

Spawn in **parallel**:
1. `documentation-generator` agent → API docs, README, ADRs, deployment guides
2. `observability-engineer` agent → Logging, metrics, tracing, alerting

Save to `.claude/output/docs/`

Mark Task 10 complete. Log: `✓ Phase 9: Docs + observability configured`

---

## Phase 10: Refinement (Conditional)

Only if code complexity was flagged during Phase 7 or 8:
- Spawn `code-simplifier` agent (Opus)
- Focus on recently modified files and high-complexity functions

If not triggered, mark as skipped.

Mark Task 11 complete. Log: `✓ Phase 10: [Refined N files | Skipped — no complexity flags]`

---

## Finalization

1. Update plan status to `completed` in plan.md
2. Update `./docs/project-changelog.md` and `./docs/development-roadmap.md` if they exist
3. Mark Task 12 complete
4. Present full SDLC summary to user:

```
## SDLC Complete (Automated)

Phase 1  Validation:     ✓ [N requirements, M assumptions]
Phase 2  Specification:  ✓ [N spec files]
Phase 3  Planning:       ✓ [N units, M waves]
Phase 4  Contracts:      ✓ [N contracts]
Phase 5  Test Specs:     ✓ [N test strategies]
Phase 6  Implementation: ✓ [N files created/modified]
Phase 7  Code Review:    ✓ [score, N issues]
Phase 8  Testing:        ✓ [pass/total, N unresolved]
Phase 9  Documentation:  ✓ [N docs generated]
Phase 10 Refinement:     ✓/skipped

Unresolved Issues: [list or "None"]
```

5. Ask user if they want to commit via `/git:cm`

---

## Important Rules

- **Read** `.claude/SOFTWARE_DEVELOPMENT_LIFECYCLE.md` at the start.
- **Follow** Orchestration Protocol in `.claude/rules/orchestration-protocol.md`.
- **Follow** development rules in `.claude/rules/development-rules.md`.
- **Token efficiency** — concise subagent prompts, summarized reports.
- **Only stop for:** unresolvable brief input, WebFetch auth failure. Everything else auto-continues.
- **Track everything** via `TaskCreate`/`TaskUpdate`/`TaskList`.
- **Log progress** after every phase with the `✓ Phase N:` format.
- **Activate skills** (`cook`, `test`, `fix`, `debug`, `code-review`, `git`) as needed.
