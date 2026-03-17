# TCMC Agents - Central Index

**Version:** 2.0.0
**Last Updated:** 2026-03-16
**Purpose:** Quick access to all documentation and agent outputs

---

## Quick Links

| What You Need | Where to Find It |
|---------------|------------------|
| 📋 SDLC Overview | [`.claude/SOFTWARE_DEVELOPMENT_LIFECYCLE.md`](../.claude/SOFTWARE_DEVELOPMENT_LIFECYCLE.md) |
| 📁 Output Structure | [`OUTPUT_STRUCTURE.md`](OUTPUT_STRUCTURE.md) |
| 🤖 Agent Definitions | [`agents/`](agents/) (22 agents) |
| 📦 Generated Outputs | [`output/`](output/) |
| 📝 Implementation Plans | [`plans/`](plans/) |
| ⚙️ Skills | [`skills/`](skills/) (9 skills) |
| 📜 Rules | [`rules/`](rules/) (3 rule files) |
| 🔧 Commands | [`commands/`](commands/) (20 commands) |
| 🪝 Hooks | [`hooks/`](hooks/) (11 hooks + lib) |

---

## Documentation Overview

### Core Documentation

1. **[Software Development Lifecycle](../.claude/docs/SOFTWARE_DEVELOPMENT_LIFECYCLE.md)**
   - Complete SDLC workflow (10 phases)
   - Agent catalog (22 specialized sub-agents)
   - Task orchestration and feedback loops
   - Execution examples and best practices

2. **[Output Structure](OUTPUT_STRUCTURE.md)**
   - Centralized output directory structure
   - File naming conventions
   - Agent output mapping
   - Workflow integration

3. **[Output README](output/README.md)**
   - Quick reference for finding outputs
   - File organization by phase
   - Examples and tips

---

## Agent Catalog

### Planning & Specification (Phase 1-3)

| Agent | Model | Purpose | Output Location |
|-------|-------|---------|-----------------|
| **product-brief-analyst** | Opus | Validates and structures product briefs | `.claude/output/briefs/validated/` |
| **tech-spec-architect** | Opus | Creates technical specifications | `.claude/output/specs/` |
| **implementation-planner** | Opus | Transforms specs into parallelizable plans | `.claude/plans/` |

### Contract Generation (Phase 4)

| Agent | Model | Purpose | Output Location |
|-------|-------|---------|-----------------|
| **contract-generator** | Sonnet | Generates interface contracts | `.claude/output/contracts/` |

### Implementation (Phase 6)

| Agent | Model | Purpose | Output Location |
|-------|-------|---------|-----------------|
| **senior-backend-engineer** | Sonnet | Backend services and APIs | Source code |
| **senior-frontend-engineer** | Sonnet | UI components and state management | Source code |
| **database-migration-specialist** | Sonnet | Schema changes and migrations | Source code + migrations |
| **devops-engineer** | Sonnet | Containerization and CI/CD | Infrastructure code |

### Quality Assurance (Phase 5, 7-8)

| Agent | Model | Purpose | Output Location |
|-------|-------|---------|-----------------|
| **test-spec-generator** | Opus | Test specifications | `.claude/output/tests/specs/` |
| **code-reviewer** | Opus | Code quality and security review | `.claude/output/reviews/` |
| **integration-test-executor** | Sonnet | Service integration tests | `.claude/output/tests/reports/integration/` |
| **e2e-test-executor** | Sonnet | End-to-end browser tests | `.claude/output/tests/reports/e2e/` |
| **security-test-executor** | Sonnet | Security scanning | `.claude/output/tests/reports/security/` |
| **performance-test-executor** | Sonnet | Load and stress testing | `.claude/output/tests/reports/performance/` |
| **accessibility-test-executor** | Sonnet | WCAG compliance | `.claude/output/tests/reports/accessibility/` |

### Documentation & Observability (Phase 9)

| Agent | Model | Purpose | Output Location |
|-------|-------|---------|-----------------|
| **documentation-generator** | Sonnet | API docs, READMEs, ADRs | `.claude/output/docs/` |
| **observability-engineer** | Sonnet | Logging, metrics, tracing | `.claude/output/docs/observability/` |

### Refinement (Phase 10)

| Agent | Model | Purpose | Output Location |
|-------|-------|---------|-----------------|
| **code-simplifier** | Opus | Code clarity improvements | Source code |

### Meta Agents

| Agent | Model | Purpose | Output Location |
|-------|-------|---------|-----------------|
| **subagent-architect** | Sonnet | Creates new sub-agent definitions | `.claude/agents/` |
| **skill-creator** | Sonnet | Creates Claude Code skills | Skills directory |

### Support & Operations (Cross-phase)

| Agent | Model | Purpose | SDLC Phases |
|-------|-------|---------|-------------|
| **debugger** | Sonnet | Systematic debugging with root cause analysis | Phase 8 |
| **git-manager** | Sonnet | Git operations with conventional commits | Phase 6-8 |
| **journal-writer** | Sonnet | Technical failure documentation, session journals | Phase 9 |

---

## Rules

| Rule File | Scope | Key Standards |
|-----------|-------|---------------|
| [`development-rules.md`](rules/development-rules.md) | All implementation agents | YAGNI/KISS/DRY, <200 LOC files, kebab-case naming, testing, security, conventional commits |
| [`orchestration-protocol.md`](rules/orchestration-protocol.md) | Orchestrator, planners | Subagent delegation patterns, sequential chaining, parallel execution, context passing |
| [`documentation-management.md`](rules/documentation-management.md) | Documentation agents | Evidence-based docs, <800 LOC, code-to-doc sync |

---

## Skills

| Skill | SDLC Phase | Purpose |
|-------|-----------|---------|
| [`planning`](skills/planning/SKILL.md) | Phase 2-3 | Structured research-to-plan workflow |
| [`cook`](skills/cook/SKILL.md) | Phase 6 | Plan-implement-test-review workflow |
| [`test`](skills/test/SKILL.md) | Phase 5, 8 | Multi-framework test execution (Jest/Vitest/pytest/etc.) |
| [`debug`](skills/debug/SKILL.md) | Phase 8 | Systematic debugging for test-fix feedback loop |
| [`code-review`](skills/code-review/SKILL.md) | Phase 7 | Structured review with edge case detection |
| [`git`](skills/git/SKILL.md) | Phase 6-8 | Conventional commits, PR workflow |
| [`fix`](skills/fix/SKILL.md) | Phase 8 | Issue routing and fix verification |
| [`task-orchestration`](skills/task-orchestration/SKILL.md) | Phase 6 | Task state management and dispatch |

---

## Commands

### Planning
| Command | Description |
|---------|-------------|
| `/plan` | Start structured planning workflow |
| `/plan:fast` | Quick planning for small features |
| `/plan:hard` | Deep planning for complex features |
| `/plan:parallel` | Parallel planning with multiple research threads |

### Implementation
| Command | Description |
|---------|-------------|
| `/cook` | Plan-implement-test-review workflow |
| `/cook:auto` | Automated cooking with minimal prompts |
| `/cook:auto:fast` | Fast automated cooking |
| `/cook:auto:parallel` | Parallel automated cooking |

### Testing & Fixing
| Command | Description |
|---------|-------------|
| `/test` | Run test suites |
| `/fix` | Intelligent issue routing |
| `/fix:test` | Fix test failures |
| `/fix:fast` | Quick fixes |
| `/fix:hard` | Deep investigation fixes |
| `/fix:parallel` | Parallel fix execution |
| `/fix:ci` | Fix CI pipeline failures |
| `/debug` | Systematic debugging |

### Code Quality
| Command | Description |
|---------|-------------|
| `/review:codebase` | Comprehensive codebase review |

### Git & Project
| Command | Description |
|---------|-------------|
| `/git:cm` | Conventional commit creation |
| `/git:pr` | Pull request creation |
| `/kanban` | Project task board overview |

### SDLC Orchestration
| Command | Description |
|---------|-------------|
| `/sdlc:phased` | Full SDLC with human-in-the-loop review gates between each phase |
| `/sdlc:auto` | Fully automated SDLC — no human gates, task-tracked, for simpler implementations |
| `/conductor` | Full documentation scaffolding |
| `/ralph-loop` | Feedback loop execution |
| `/cancel-ralph` | Cancel active feedback loop |

---

## Hooks

### Quality Gate Hooks
| Hook | Event | Purpose |
|------|-------|---------|
| `session-init.cjs` | SessionStart | Project detection, environment setup |
| `dev-rules-reminder.cjs` | UserPromptSubmit | Inject development rules context |
| `scout-block.cjs` | PreToolUse | Block access to node_modules/.git directories |
| `privacy-block.cjs` | PreToolUse | Block access to .env/credentials files |
| `modularization-hook.js` | PostToolUse | Suggest splitting files exceeding 200 LOC |
| `subagent-init.cjs` | SubagentStart | Context injection for sub-agents |

### Notification Hooks
| Hook | Event | Purpose |
|------|-------|---------|
| `notifications/notify.cjs` | Stop | Send notifications via Discord/Slack/Telegram |

### Pre-existing SDLC Hooks
| Hook | Event | Purpose |
|------|-------|---------|
| `session_startup.sh` | SessionStart | SDLC startup checklist |
| `context_reinject.sh` | SessionStart:compact | Re-inject project context |
| `orchestration_snapshot.sh` | PreCompact | Snapshot orchestration state |
| `ralph-loop.sh` | Stop | Feedback loop handler |

---

## Output Directory Structure

```
.claude/
├── INDEX.md                      # ⬅️ You are here
├── OUTPUT_STRUCTURE.md           # Complete output specification
├── SOFTWARE_DEVELOPMENT_LIFECYCLE.md
├── settings.json                 # Hook registrations and config
├── .ck.json                      # Toolkit configuration
├── .ckignore                     # Scout-block patterns
│
├── agents/                       # Agent definitions (22 agents)
│   ├── product-brief-analyst.md
│   ├── tech-spec-architect.md
│   ├── debugger.md
│   ├── git-manager.md
│   └── ... (18 more agents)
│
├── rules/                        # Development rules (3 files)
│   ├── development-rules.md
│   ├── orchestration-protocol.md
│   └── documentation-management.md
│
├── skills/                       # Skill definitions (9 skills)
│   ├── task-orchestration/       # Pre-existing
│   ├── planning/
│   ├── cook/
│   ├── test/
│   ├── debug/
│   ├── code-review/
│   ├── git/
│   ├── fix/
│
├── commands/                     # Slash commands (24 commands)
│   ├── conductor.md              # Pre-existing
│   ├── ralph-loop.md             # Pre-existing
│   ├── cancel-ralph.md           # Pre-existing
│   └── fix/, git/, review/, plan/, cook/
│
├── hooks/                        # Hook scripts (11 hooks + lib)
│   ├── lib/                      # Shared utilities (15 files)
│   ├── scout-block/              # Scout-block modules
│   ├── notifications/            # Notification providers
│   ├── session-init.cjs, privacy-block.cjs, ...
│   └── session_startup.sh, ...   # Pre-existing hooks
│
├── plans/                        # Implementation plans
│   └── *.md
│
└── output/                       # Generated artifacts
    ├── README.md
    ├── briefs/                   # Phase 1
    ├── specs/                    # Phase 2
    ├── contracts/                # Phase 4
    ├── tests/                    # Phase 5, 8
    ├── reviews/                  # Phase 7
    └── docs/                     # Phase 9
```

---

## Typical Workflow

### Starting a New Project

```mermaid
graph TD
    A[Raw Product Brief] --> B[product-brief-analyst]
    B --> C[.claude/output/briefs/validated/]
    C --> D[tech-spec-architect]
    D --> E[.claude/output/specs/]
    E --> F[implementation-planner]
    F --> G[.claude/plans/]
    G --> H[contract-generator]
    H --> I[.claude/output/contracts/]
    I --> J[/task-orchestration]
    J --> K[Implementation Agents]
    K --> L[Source Code]
```

### Quick Start Commands

1. **Validate a product brief:**
   ```
   Use Task tool with product-brief-analyst agent
   Input: Your product brief
   Output: .claude/output/briefs/validated/<name>.md
   ```

2. **Create technical specs:**
   ```
   Use Task tool with tech-spec-architect agent
   Input: .claude/output/briefs/validated/<name>.md
   Output: .claude/output/specs/frontend/, backend/, etc.
   ```

3. **Generate implementation plan:**
   ```
   Use Task tool with implementation-planner agent
   Input: .claude/output/specs/**/*.md
   Output: .claude/plans/<feature>.md
   ```

4. **Generate contracts:**
   ```
   Use Task tool with contract-generator agent
   Input: .claude/plans/*.md (contract requirements)
   Output: .claude/output/contracts/**/*
   ```

5. **Orchestrate implementation:**
   ```
   Use Skill tool: /task-orchestration
   Input: .claude/plans/*.md
   Output: Parallel execution across agents
   ```

---

## Finding Outputs

### By Phase

| SDLC Phase | Output Location | Example |
|------------|----------------|---------|
| Phase 1: Validation | `.claude/output/briefs/validated/` | `messenger-app-validated-brief-2026-02-04.md` |
| Phase 2: Specification | `.claude/output/specs/` | `backend-spec-message-api-2026-02-04.md` |
| Phase 3: Planning | `.claude/plans/` | `backend-websocket-api-plan.md` |
| Phase 4: Contracts | `.claude/output/contracts/` | `api/message-api-v1.openapi.yaml` |
| Phase 5: Test Specs | `.claude/output/tests/specs/` | `test-spec-messenger-app-2026-02-04.md` |
| Phase 7: Code Review | `.claude/output/reviews/` | `review-message-service-2026-02-04.md` |
| Phase 8: Test Reports | `.claude/output/tests/reports/` | `integration-report-2026-02-04.md` |
| Phase 9: Documentation | `.claude/output/docs/` | `api/message-api-reference.md` |

### By Agent

| Agent | Output Pattern | Location |
|-------|----------------|----------|
| product-brief-analyst | `<name>-validated-brief-<date>.md` | `.claude/output/briefs/validated/` |
| tech-spec-architect | `<layer>-spec-<feature>-<date>.md` | `.claude/output/specs/<layer>/` |
| implementation-planner | `<domain>-<feature>-plan.md` | `.claude/plans/` |
| contract-generator | `<type>/<name>.*` | `.claude/output/contracts/<type>/` |
| test-spec-generator | `test-spec-<project>-<date>.md` | `.claude/output/tests/specs/` |
| *-test-executor | `<type>-report-<date>.md` | `.claude/output/tests/reports/<type>/` |
| code-reviewer | `review-<scope>-<date>.md` | `.claude/output/reviews/` |
| documentation-generator | Varies by doc type | `.claude/output/docs/<type>/` |

---

## Common Tasks

### View Latest Test Results

```bash
# Integration tests
ls -t .claude/output/tests/reports/integration/ | head -1

# E2E tests
ls -t .claude/output/tests/reports/e2e/ | head -1

# All recent test reports
find .claude/output/tests/reports/ -name "*.md" -type f -mtime -7
```

### Find Outputs for a Feature

```bash
# Search across all outputs
grep -r "message streaming" .claude/output/

# Find specs
find .claude/output/specs/ -name "*message*"

# Find plans
find .claude/plans/ -name "*message*"

# Find contracts
find .claude/output/contracts/ -name "*message*"
```

### Check Latest Generated Files

```bash
# Last 10 files generated
find .claude/output/ -type f -name "*.md" -printf '%T@ %p\n' | sort -rn | head -10 | cut -d' ' -f2
```

---

## Metadata Standards

All generated files include a metadata header:

```yaml
---
generated_by: agent-name
generation_date: YYYY-MM-DD HH:MM:SS
source_input: path-to-input-or-description
version: X.Y.Z
tech_stack: detected-technologies
status: draft | review | approved | deprecated
---
```

---

## Tips & Best Practices

### For Users

1. **Always start with validation** - Use product-brief-analyst before diving into specs
2. **Review outputs before next phase** - Each phase builds on the previous
3. **Keep outputs in version control** - Track evolution of requirements and specs
4. **Reference standard paths** - Use the centralized output structure
5. **Clean up periodically** - Archive old test reports (see OUTPUT_STRUCTURE.md)

### For Agents

1. **Write to standard locations** - Use paths defined in OUTPUT_STRUCTURE.md
2. **Include metadata headers** - Always add generation metadata
3. **Follow naming conventions** - Use kebab-case and include dates
4. **Create directories as needed** - Don't assume directories exist
5. **Reference inputs correctly** - Document what spec/plan you're working from

---

## Getting Help

- **SDLC Questions**: See [SOFTWARE_DEVELOPMENT_LIFECYCLE.md](../docs/SOFTWARE_DEVELOPMENT_LIFECYCLE.md)
- **Output Questions**: See [OUTPUT_STRUCTURE.md](OUTPUT_STRUCTURE.md)
- **Agent Questions**: See individual agent files in [`agents/`](agents/)
- **Skill Questions**: Use `/help` in Claude Code

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2026-03-10 | Integrated Awssome-Claude-Kit: +8 agents, +10 skills, +21 commands, +10 hooks, +4 rules |
| 1.0.0 | 2026-02-04 | Initial centralized output structure |

---

**Quick Navigation:**
- [← Back to Root](../)
- [SDLC Documentation](../docs/SOFTWARE_DEVELOPMENT_LIFECYCLE.md)
- [Output Structure](OUTPUT_STRUCTURE.md)
- [Generated Outputs](output/)
- [Implementation Plans](plans/)
- [Agent Definitions](agents/)
