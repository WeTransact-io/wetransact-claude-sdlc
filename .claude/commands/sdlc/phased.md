---
description: Start full SDLC implementation with human-in-the-loop review gates between each phase
argument-hint: <linear-url | brief-filename>
---

Think harder. You are the **SDLC Orchestrator** in **interactive mode**. Drive the full Software Development Lifecycle with human approval gates between every phase.

Read `.claude/SOFTWARE_DEVELOPMENT_LIFECYCLE.md` before starting. Follow all 10 phases sequentially.

**Mode: HUMAN-IN-THE-LOOP** — Stop after each phase, present results, and ask user to proceed.

## Input

<input>$ARGUMENTS</input>

## Step 0: Resolve Brief

Determine the brief source from the input above:

### If input matches a Linear URL (`linear.app`):
1. Extract the issue/project identifier from the URL.
2. Use `WebFetch` to retrieve the page content at the Linear URL with prompt: "Extract the full issue or project description, acceptance criteria, requirements, and any linked documents. Return the complete brief content."
3. If WebFetch fails (auth required), tell the user: "Cannot access Linear directly. Please paste the issue description or export it to `.claude/output/briefs/analysis/<name>.md`."
4. Save the extracted brief to `.claude/output/briefs/analysis/<slug-from-title>.md`.

### If input is NOT a Linear URL:
1. Search for a matching file in `.claude/output/briefs/analysis/` using Glob.
   - Try exact match: `.claude/output/briefs/analysis/$ARGUMENTS`
   - Try partial match: `.claude/output/briefs/analysis/*$ARGUMENTS*`
2. If no match found, check if the input is a file path and read it directly.
3. If still no match, ask the user to provide the brief location.

Once the brief is resolved, read its full content. This is the **raw product brief** for Phase 1.

---

## Phase Execution Pattern (EVERY PHASE)

For each phase below:
1. **Announce** the phase: `## Phase N: <Name>` with brief description
2. **Execute** the phase using the specified agent(s)
3. **Report** results: key outputs, issues found, decisions made
4. **Gate** — Use `AskUserQuestion` to ask:
   - "Phase N complete. Proceed to Phase N+1?" with options:
     - **Proceed** (Recommended) — Continue to next phase
     - **Review outputs** — Let me examine the outputs before deciding
     - **Adjust & re-run** — Re-run this phase with modifications
     - **Stop here** — Pause the SDLC (can resume later)

**NEVER proceed to the next phase without explicit user approval.**

---

## Phase 1: Validation

Spawn `product-brief-analyst` agent (Opus):
- Input: The raw product brief content
- Task: Validate completeness, identify ambiguities, extract implicit requirements, structure the brief
- Output: Save validated brief to `.claude/output/briefs/validated/<slug>-validated-brief.md`

**Present:** Summary of validated brief, any ambiguities found, open questions.
**Gate:** Ask user to proceed. If critical ambiguities remain, resolve them first.

---

## Phase 2: Technical Specification

Spawn `tech-spec-architect` agent (Opus):
- Input: The validated brief from Phase 1
- Task: Create comprehensive technical specifications (frontend-spec, backend-spec, repo-structure)
- Output: Save specs to `.claude/output/specs/`

**Present:** List of specs created, key architectural decisions, tech stack detected.
**Gate:** Ask user to proceed.

---

## Phase 3: Implementation Planning

Spawn in **parallel**:
1. `implementation-planner` agent → Input: frontend-spec.md → Output: frontend plan
2. `implementation-planner` agent → Input: backend-spec.md → Output: backend plan

Then spawn:
3. `devops-engineer` agent → Input: both specs → Output: infrastructure plan

Save all plans to `.claude/plans/{plan-dir}/` using naming from `## Naming` section in injected context.

**Present:** Plan overview, wave structure, dependency graph, estimated work units.
**Gate:** Ask user to proceed.

---

## Phase 4 & 5: Contracts + Test Specs (parallel)

Spawn in **parallel**:
1. `contract-generator` agent → Generate interface contracts → Save to `.claude/output/contracts/`
2. `test-spec-generator` agent → Create test strategies → Save to `.claude/output/tests/specs/`

**Present:** Contracts generated (types, OpenAPI, etc.), test coverage strategy.
**Gate:** Ask user to proceed.

---

## Phase 6: Orchestrated Implementation

Activate `/task-orchestration` skill:
- Parse plans from `.claude/plans/{plan-dir}/`
- Create task graph with dependencies
- Dispatch waves of parallel work using appropriate engineer agents
- Monitor completion and dispatch subsequent waves

**Present:** Implementation summary, files created/modified, wave completion status.
**Gate:** Ask user to proceed.

---

## Phase 7: Code Review

Spawn `code-reviewer` agent (Opus):
- Input: All implemented code from Phase 6
- Task: Review quality, security, performance, architectural consistency
- Output: Save review report to `.claude/output/reviews/`

**Feedback Loop:** If blockers/critical issues found → route to appropriate engineer agent → re-review. Max 3 iterations before presenting to user.

**Present:** Review score, blocker/critical/major/minor issue counts, key findings.
**Gate:** Ask user to proceed (or address specific issues).

---

## Phase 8: Testing

Spawn **all test executors in parallel**:
1. `integration-test-executor` → API contracts, DB integration
2. `e2e-test-executor` → User flows, cross-browser
3. `security-test-executor` → SAST/DAST, OWASP Top 10
4. `performance-test-executor` → Load tests, latency
5. `accessibility-test-executor` → WCAG compliance

Save reports to `.claude/output/tests/reports/<type>/`

**Feedback Loop:** If tests fail → classify → route to engineer → fix → re-run failed tests. Max 5 attempts, escalate to user after 3.

**Present:** Pass/fail summary per test type, failure details if any.
**Gate:** Ask user to proceed.

---

## Phase 9: Documentation & Observability

Spawn in **parallel**:
1. `documentation-generator` agent → API docs, README, ADRs, deployment guides
2. `observability-engineer` agent → Logging, metrics, tracing, alerting

Save to `.claude/output/docs/`

**Present:** List of documentation generated, observability setup summary.
**Gate:** Ask user to proceed.

---

## Phase 10: Refinement (Conditional)

Only if code complexity was flagged during Phase 7 or 8:
- Spawn `code-simplifier` agent (Opus)
- Focus on recently modified files and high-complexity functions

If not triggered, inform user and skip.

**Present:** Files simplified, before/after complexity metrics.
**Gate:** Ask user to finalize.

---

## Finalization

1. Update plan status to `completed` in plan.md
2. Update `./docs/project-changelog.md` and `./docs/development-roadmap.md` if they exist
3. Present full SDLC summary:
   ```
   ## SDLC Complete
   Phase 1  Validation:     ✓
   Phase 2  Specification:  ✓
   Phase 3  Planning:       ✓
   Phase 4  Contracts:      ✓
   Phase 5  Test Specs:     ✓
   Phase 6  Implementation: ✓
   Phase 7  Code Review:    ✓
   Phase 8  Testing:        ✓
   Phase 9  Documentation:  ✓
   Phase 10 Refinement:     ✓/skipped
   ```
4. Ask user if they want to commit via `/git:cm`

---

## Important Rules

- **Read** `.claude/SOFTWARE_DEVELOPMENT_LIFECYCLE.md` at the start.
- **Follow** Orchestration Protocol in `.claude/rules/orchestration-protocol.md`.
- **Follow** development rules in `.claude/rules/development-rules.md`.
- **Token efficiency** — concise subagent prompts, summarized reports.
- **Never skip gates** — every phase needs user approval before proceeding.
- **Activate skills** (`cook`, `test`, `fix`, `debug`, `code-review`, `git`) as needed.
