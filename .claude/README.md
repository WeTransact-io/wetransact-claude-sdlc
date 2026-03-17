# TCMC Agents — Claude Code SDLC Toolkit

A complete `.claude/` environment that implements an end-to-end **Software Development Lifecycle (SDLC)** for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Clone it into your workspace and get 22 specialized agents, 9 skills, 20 commands, and automated quality gates — all orchestrated through a 10-phase pipeline.

```
Product Brief → Validation → Specification → Planning → Contracts
     → Implementation → Review → Testing → Documentation → Deployment
                            ↑                        │
                            └────── Fix Loop ────────┘
```

---

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Agents (22)](#agents)
- [Skills (9)](#skills)
- [Commands (20)](#commands)
- [Hooks (12 registrations)](#hooks)
- [Rules (3)](#rules)
- [Security](#security)
- [Directory Structure](#directory-structure)
- [Configuration](#configuration)
- [License](#license)

---

## Features

- **10-phase SDLC pipeline** — from product brief validation to production deployment
- **22 specialized sub-agents** — each excels at one domain (planning, backend, frontend, testing, security, DevOps, etc.)
- **9 composable skills** — reusable workflows for planning, cooking (implement), fixing, testing, debugging, code review, git ops, browser testing, and task orchestration
- **18 slash commands** — quick-access shortcuts (`/cook`, `/fix`, `/plan`, `/test`, `/git:cm`, `/git:pr`, etc.)
- **Automated quality gates** — hooks enforce dev rules, block credential leaks, detect oversized files, and inject context into sub-agents
- **Tech-stack agnostic** — agents auto-detect your framework, language, and tooling
- **Browser testing via Playwright** — visual regression, accessibility audits, form automation
- **Notification support** — Discord, Slack, and Telegram notifications on session completion

---

## Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| **Node.js** | >= 18.0.0 | Required for hooks and Playwright |
| **Git** | Any recent | Version control |
| **Claude Code CLI** | Latest | [Install guide](https://docs.anthropic.com/en/docs/claude-code) |
| **Python 3** | >= 3.8 | Optional — for skills with Python dependencies |

### Optional

| Tool | Purpose |
|------|---------|
| **Playwright CLI** | Browser automation, visual testing, accessibility audits |
| **GitHub CLI (`gh`)** | PR creation, issue management, CI/CD log analysis |
| **PostgreSQL (`psql`)** | Database debugging |

---

## Installation

### Step 1: Clone the toolkit

```bash
# Unix/macOS/WSL                                                                              
git clone https://github.com/WeTransact-io/wetransact-claude-sdlc /tmp/tcmc-sdlc            
cp -rn /tmp/tcmc-sdlc/* /path/to/your-project/.claude/
cp -rn /tmp/tcmc-sdlc/.* /path/to/your-project/.claude/ 2>/dev/null
rm -rf /tmp/tcmc-sdlc

# Windows (PowerShell)
git clone https://github.com/WeTransact-io/wetransact-claude-sdlc $env:TEMP\tcmc-sdlc       
Copy-Item -Recurse "$env:TEMP\tcmc-sdlc\*" -Destination "C:\path\to\your-project\.claude"   
-ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:TEMP\tcmc-sdlc"
```

Or clone directly into your project without overwriting existing files (recommended):

```bash
cd /path/to/your-project
git clone https://github.com/WeTransact-io/wetransact-claude-sdlc /tmp/tcmc-sdlc
# Copy only new files, never overwrite existing ones (-n = no clobber)
cp -rn /tmp/tcmc-sdlc/* .claude/
cp -rn /tmp/tcmc-sdlc/.* .claude/ 2>/dev/null
rm -rf /tmp/tcmc-sdlc
```

### Step 2: Install Playwright CLI (recommended)

```bash
npm install -g @playwright/cli@latest
```

Enables browser-based testing: screenshots, responsive checks, accessibility audits, form automation, and console error collection.

### Step 3: Verify installation

```bash
# Check the setup loaded correctly
ls .claude/agents/       # Should list 22 .md files
ls .claude/skills/       # Should list 9 directories
ls .claude/commands/     # Should list command files and subdirs
ls .claude/hooks/        # Should list hook scripts
```

### Step 4: Configure notifications (optional)

Set environment variables for session-completion notifications:

```bash
# Discord
export DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."

# Slack
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/..."

# Telegram
export TELEGRAM_BOT_TOKEN="your-bot-token"
export TELEGRAM_CHAT_ID="your-chat-id"
```

---

## Quick Start

```
/sdlc:phased          # Full SDLC with human review gates between phases
/sdlc:auto            # Full SDLC fully automated (for simpler features)
/plan:hard            # Research + analyze + create implementation plan
/cook                 # Implement a feature (plan → code → test → review)
/test                 # Run test suites
/fix                  # Fix any bug or error (auto-routes by type)
/git:cm               # Stage + commit with conventional format
/git:pr               # Create a pull request
/review:codebase      # Full codebase scan and analysis
```

---

## Agents

22 specialized sub-agents, each with defined tools, model preferences, and output locations.

### Planning & Specification

| Agent | Purpose |
|-------|---------|
| `product-brief-analyst` | Validates and structures raw product briefs before development |
| `tech-spec-architect` | Creates production-ready technical specifications |
| `implementation-planner` | Transforms specs into parallelizable execution plans |
| `contract-generator` | Generates tech-agnostic API contracts, types, and schemas |

### Implementation

| Agent | Purpose |
|-------|---------|
| `senior-backend-engineer` | Production-ready backend systems, APIs, services |
| `senior-frontend-engineer` | UI components, state management, responsive interfaces |
| `database-migration-specialist` | Safe schema changes, data migrations, rollback procedures |
| `devops-engineer` | CI/CD pipelines, containerization, cloud deployments |

### Quality Assurance

| Agent | Purpose |
|-------|---------|
| `code-reviewer` | Code quality, security, performance, architectural consistency |
| `test-spec-generator` | Comprehensive test specification documents |
| `integration-test-executor` | Service-to-service and API contract tests |
| `e2e-test-executor` | End-to-end browser tests (Playwright/Cypress) |
| `security-test-executor` | SAST/DAST scans and vulnerability reports |
| `performance-test-executor` | Load testing with k6/Locust and bottleneck analysis |
| `accessibility-test-executor` | WCAG compliance with axe-core/pa11y |

### Documentation & Observability

| Agent | Purpose |
|-------|---------|
| `documentation-generator` | API docs, READMEs, ADRs, deployment guides |
| `observability-engineer` | Monitoring, logging, tracing, alerting infrastructure |

### Refinement & Support

| Agent | Purpose |
|-------|---------|
| `code-simplifier` | Simplifies code for clarity and maintainability |
| `debugger` | Systematic debugging with root cause analysis |
| `git-manager` | Conventional commits, staging, pushing, PR workflow |

### Meta

| Agent | Purpose |
|-------|---------|
| `subagent-architect` | Designs and creates new sub-agent definitions |
| `skill-creator` | Creates Claude Code skills (SKILL.md files) |

---

## Skills

9 composable skills that agents and commands activate as needed.

| Skill | Command | Description |
|-------|---------|-------------|
| **planning** | `/plan` | Research-to-plan workflow with phased output |
| **cook** | `/cook` | Plan → implement → test → review pipeline |
| **fix** | `/fix` | Smart-routed bug fixing (auto-detects issue type) |
| **test** | `/test` | Multi-framework test execution and coverage analysis |
| **debug** | `/debug` | Systematic root cause analysis |
| **code-review** | `/review:codebase` | Structured review with edge case detection |
| **git** | `/git:cm`, `/git:pr` | Conventional commits, PR creation, secret scanning |
| **playwright-cli** | — | Browser automation: screenshots, a11y, forms, visual regression |
| **task-orchestration** | `/kanban` | Parallel workflow orchestration and dependency tracking |

---

## Commands

18 slash commands organized by workflow stage.

### Planning

| Command | Description |
|---------|-------------|
| `/plan:fast` | Quick plan — analyze only, no research |
| `/plan:hard` | Deep plan — research + analyze + create |
| `/plan:parallel` | Plan with parallel-executable phases |
| `/plan:validate` | Validate plan with focused stakeholder questions |

### Implementation

| Command | Description |
|---------|-------------|
| `/cook` | Full implement workflow (plan → code → test → review) |
| `/cook:auto` | Automated implementation with minimal prompts |
| `/cook:auto:fast` | Fast auto — no research, just analyze + implement |
| `/cook:auto:parallel` | Parallel phases with engineer agents |

### Fixing

| Command | Description |
|---------|-------------|
| `/fix` | Smart-routed fix (auto-detects issue type) |
| `/fix:fast` | Quick fix for small issues |
| `/fix:hard` | Deep investigation with sub-agents |
| `/fix:test` | Run tests and fix failures |
| `/fix:ci` | Analyze GitHub Actions logs and fix CI issues |
| `/fix:parallel` | Fix with parallel engineer agents |

### Code Quality & Git

| Command | Description |
|---------|-------------|
| `/review:codebase` | Full codebase scan and analysis |
| `/git:cm` | Stage all files + create conventional commit |
| `/git:pr` | Create a pull request |

### SDLC Orchestration

| Command | Description |
|---------|-------------|
| `/sdlc:phased` | Full SDLC with human-in-the-loop review gates between each phase |
| `/sdlc:auto` | Fully automated SDLC — task-tracked, no human gates between phases |
| `/conductor` | Full SDLC documentation scaffolding |

---

## Hooks

12 hook registrations across 7 lifecycle events provide automated quality gates.

| Event | Hook | Purpose |
|-------|------|---------|
| **SessionStart** | `session-init.cjs` | Project detection, plan resolution, environment setup |
| **SessionStart** | `session_startup.sh` | SDLC startup checklist |
| **SessionStart** (compact) | `context_reinject.sh` | Re-inject project context after compaction |
| **UserPromptSubmit** | `dev-rules-reminder.cjs` | Inject development rules, paths, and naming conventions |
| **PreToolUse** | `scout-block.cjs` | Block access to `node_modules/`, `.git/`, vendor dirs |
| **PreToolUse** | `privacy-block.cjs` | Block access to `.env`, credentials, and secrets |
| **PostToolUse** | `modularization-hook.js` | Suggest splitting files exceeding 200 LOC |
| **SubagentStart** | `subagent-init.cjs` | Context injection for all sub-agents |
| **SubagentStart** | Quality gate (LLM) | SDLC phase transition validation for implementation agents |
| **Stop** | Compliance check (LLM) | Documentation update reminder |
| **Stop** | `notifications/notify.cjs` | Discord/Slack/Telegram notifications |
| **PreCompact** | `orchestration_snapshot.sh` | Snapshot orchestration state before context compaction |

All hooks follow a **fail-open pattern** — they exit 0 on errors to avoid blocking Claude operations.

---

## Rules

3 rule files loaded automatically into every session.

| Rule | Scope | Key Standards |
|------|-------|---------------|
| **development-rules.md** | All agents | YAGNI/KISS/DRY, <200 LOC files, kebab-case naming, security, conventional commits |
| **orchestration-protocol.md** | Orchestrator & planners | Sub-agent delegation, sequential chaining, parallel execution, context passing |
| **documentation-management.md** | Documentation agents | Evidence-based docs, <800 LOC, code-to-doc sync, plan organization |

---

## Security

### Credential Protection

The `privacy-block.cjs` hook **blocks all tool access** to sensitive files:

- `.env`, `.env.*` files
- `credentials.json`, `serviceAccountKey.json`
- Private keys (`*.pem`, `*.key`)
- Any file matching common secret patterns

### Path Blocking

The `scout-block.cjs` hook prevents agents from reading into:

- `node_modules/`, `.git/`, `dist/`, `build/`
- `__pycache__/`, `.venv/`, `vendor/`, `target/`
- `coverage/`, `.next/`, `.nuxt/`

Configurable via `.ckignore`.

### Git Safety

The `git` skill includes:

- **Secret scanning** before commits — prevents accidental credential pushes
- **Conventional commit enforcement** — clean, professional commit messages
- **No `--force` push to main/master** without explicit user confirmation

### Hook Fail-Open Pattern

All hooks exit 0 on internal errors. This prevents a broken hook from blocking Claude operations while still providing protection when functioning normally.

### Best Practices

- Never commit `.env` files or API keys — the privacy hook blocks access, but `.gitignore` should also exclude them
- Review `settings.json` hook registrations after installation
- Keep Node.js updated for security patches in hook dependencies

---

## Directory Structure

```
.claude/
├── settings.json                 # Hook registrations and config
├── .ck.json                      # Toolkit configuration
├── .ckignore                     # Path blocking patterns
├── SOFTWARE_DEVELOPMENT_LIFECYCLE.md
├── INDEX.md                      # Central navigation index
├── OUTPUT_STRUCTURE.md           # Output directory spec
│
├── agents/                       # 22 agent definitions
│   ├── product-brief-analyst.md
│   ├── tech-spec-architect.md
│   ├── senior-backend-engineer.md
│   ├── senior-frontend-engineer.md
│   └── ... (18 more)
│
├── skills/                       # 9 composable skills
│   ├── planning/
│   ├── cook/
│   ├── fix/
│   ├── test/
│   ├── debug/
│   ├── code-review/
│   ├── git/
│   ├── playwright-cli/
│   └── task-orchestration/
│
├── commands/                     # 20 slash commands
│   ├── conductor.md
│   ├── cook/
│   ├── fix/
│   ├── git/
│   ├── plan/
│   ├── review/
│   └── sdlc/                    # /sdlc:phased, /sdlc:auto
│
├── hooks/                        # Hook scripts + libraries
│   ├── session-init.cjs
│   ├── dev-rules-reminder.cjs
│   ├── scout-block.cjs
│   ├── privacy-block.cjs
│   ├── modularization-hook.js
│   ├── subagent-init.cjs
│   ├── notifications/
│   ├── lib/                      # 15 shared utility modules
│   └── scout-block/              # Path-matching modules
│
├── rules/                        # 3 auto-loaded rule files
│   ├── development-rules.md
│   ├── orchestration-protocol.md
│   └── documentation-management.md
│
├── plans/                        # Implementation plans
│   └── reports/                  # Research and analysis reports
│
└── output/                       # Generated artifacts
    ├── briefs/validated/         # Phase 1: Validated briefs
    ├── specs/                    # Phase 2: Technical specs
    ├── contracts/                # Phase 4: API contracts
    ├── tests/specs/              # Phase 5: Test specs
    ├── tests/reports/            # Phase 8: Test reports
    ├── reviews/                  # Phase 7: Code reviews
    └── docs/                     # Phase 9: Documentation
```

---

## Configuration

### `.ck.json` — Toolkit Settings

```jsonc
{
  "docs": { "maxLoc": 800 },
  "plan": {
    "naming": "{date}-{issue}-{slug}",
    "dateFormat": "YYMMDD-HHmm",
    "validation": { "mode": "prompt", "questions": "3-8" }
  },
  "paths": {
    "docs": ".claude/output/docs",
    "plans": ".claude/plans"
  }
}
```

### `.ckignore` — Path Blocking

```
node_modules
dist
build
.next
.nuxt
__pycache__
.venv
vendor
target
.git
coverage
```

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `DISCORD_WEBHOOK_URL` | Discord notification webhook |
| `SLACK_WEBHOOK_URL` | Slack notification webhook |
| `TELEGRAM_BOT_TOKEN` | Telegram bot token |
| `TELEGRAM_CHAT_ID` | Telegram chat ID |
| `MCP_TIMEOUT` | MCP plugin timeout (default: 300s) |

---

## SDLC Phases

| Phase | Stage | Primary Agents |
|-------|-------|----------------|
| 1 | **Validation** | product-brief-analyst |
| 2 | **Specification** | tech-spec-architect |
| 3 | **Planning** | implementation-planner |
| 4 | **Contracts** | contract-generator |
| 5 | **Test Specs** | test-spec-generator |
| 6 | **Implementation** | senior-backend-engineer, senior-frontend-engineer, database-migration-specialist, devops-engineer |
| 7 | **Code Review** | code-reviewer |
| 8 | **Testing** | integration-test-executor, e2e-test-executor, security-test-executor, performance-test-executor, accessibility-test-executor |
| 9 | **Documentation** | documentation-generator, observability-engineer |
| 10 | **Refinement** | code-simplifier |

For complete workflow details, see [SOFTWARE_DEVELOPMENT_LIFECYCLE.md](.claude/SOFTWARE_DEVELOPMENT_LIFECYCLE.md).

---
