# Software Development Lifecycle (SDLC) Documentation

## Agent-Driven Development Workflow

**Version:** 1.0.0
**Last Updated:** 2025-01-26
**Total Agents:** 22 specialized sub-agents

---

## Table of Contents

1. [Overview](#1-overview)
2. [Agent Catalog](#2-agent-catalog)
3. [Complete Workflow Diagram](#3-complete-workflow-diagram)
4. [Phase Breakdown](#4-phase-breakdown)
5. [Task Orchestration](#5-task-orchestration)
6. [Feedback Loop: Test-Fix Cycle](#6-feedback-loop-test-fix-cycle)
7. [Execution Examples](#7-execution-examples)
8. [Best Practices](#8-best-practices)
9. [Toolkit Integration](#9-toolkit-integration)

---

## 1. Overview

This document describes the complete software development lifecycle powered by specialized AI sub-agents. The system transforms a product brief into production-ready software through coordinated parallel execution.

### Core Principles

1. **Parallel Execution**: Maximize concurrent work through contract-driven decoupling
2. **Specialization**: Each agent excels at one domain
3. **Quality Gates**: Code review and testing before progression
4. **Feedback Loops**: Test failures route back to engineers for fixes
5. **Tech-Stack Agnostic**: All agents adapt to detected technology

### High-Level Flow

```
Product Brief → Validation → Specification → Planning → Contracts → Implementation → Review → Testing → Documentation → Deployment
                                                              ↑                              │
                                                              └──────── Fix Loop ───────────┘
```

---

## 2. Agent Catalog

### 2.1 Planning & Specification Agents

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `product-brief-analyst` | Opus | Validates, clarifies, and structures raw product briefs | Read, Glob, Grep, WebFetch, WebSearch |
| `tech-spec-architect` | Opus | Creates comprehensive technical specifications | Read, Glob, Grep, WebFetch, WebSearch, Write, Edit |
| `implementation-planner` | Opus | Transforms specs into parallelizable execution plans | Read, Grep, Glob, WebFetch, WebSearch, Write |
| `contract-generator` | Opus | Generates interface contracts (tech-stack agnostic) | Read, Grep, Glob, Write |

### 2.2 Implementation Agents

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `senior-backend-engineer` | Sonnet | Backend services, APIs, data layer, auth, caching, file storage, real-time features | Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch |
| `senior-frontend-engineer` | Sonnet | UI components, state management, API integration (auto-detects stack: React/Vue/Angular/etc.) | Read, Write, Edit, Glob, Grep, Bash, WebFetch, WebSearch + playwright-cli skill |
| `database-migration-specialist` | Sonnet | Safe schema changes, data migrations, rollback procedures (tech-stack agnostic) | Read, Write, Edit, Bash, Grep, Glob |

### 2.3 Infrastructure Agents

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `devops-engineer` | Sonnet | Containerization, CI/CD pipelines, IaC, cloud deployments (tech-stack and cloud-agnostic) | Read, Write, Edit, Bash, Grep, Glob |

### 2.4 Quality Assurance Agents

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `code-reviewer` | Opus | Code quality, security, performance, architecture review (tech-stack agnostic) | Read, Grep, Glob, Write |
| `test-spec-generator` | Opus | Comprehensive test specifications (technology-agnostic, adapts to stack) | Read, Grep, Glob, Bash, Write, Edit |
| `integration-test-executor` | Sonnet | Service-to-service tests, API contracts, database integration (tech-stack agnostic) | Read, Grep, Glob, Bash, Write, Edit |
| `e2e-test-executor` | Sonnet | End-to-end browser tests with Playwright/Cypress | Read, Grep, Glob, Bash, Write, Edit + playwright-cli skill |
| `security-test-executor` | Sonnet | SAST, DAST, dependency scanning, OWASP Top 10 tests | Read, Grep, Glob, Bash, Write, Edit |
| `performance-test-executor` | Sonnet | Load testing (k6/Locust), latency analysis, bottleneck detection | Read, Grep, Glob, Bash, Write, Edit |
| `accessibility-test-executor` | Sonnet | WCAG compliance (axe-core/pa11y), keyboard navigation, screen reader tests | Read, Grep, Glob, Bash, Write, Edit + playwright-cli skill |

### 2.5 Documentation & Observability Agents

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `documentation-generator` | Sonnet | API docs, READMEs, ADRs, deployment guides, user guides (tech-stack agnostic) | Read, Write, Edit, Glob, Grep |
| `observability-engineer` | Sonnet | Logging, metrics, distributed tracing, alerting, dashboards (tech-stack and platform-agnostic) | Read, Write, Edit, Bash, Grep, Glob |

### 2.6 Refinement Agents

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `code-simplifier` | Opus | Code clarity and maintainability improvements (preserves functionality) | Read, Write, Edit, Glob, Grep |

### 2.7 Meta Agents

| Agent | Model | Purpose | Tools |
|-------|-------|---------|-------|
| `subagent-architect` | Sonnet | Creates specialized sub-agent definitions | Read, Write, Glob, Grep, Bash |
| `skill-creator` | Sonnet | Creates Claude Code skills (SKILL.md files) | Read, Write, Glob, Grep, Bash |

### 2.8 Support & Operations Agents

These agents complement the core SDLC phases with cross-cutting capabilities:

| Agent | Model | Primary Use | SDLC Phases |
|-------|-------|-------------|-------------|
| `debugger` | Sonnet | Systematic debugging with root cause analysis | Phase 8 |
| `git-manager` | Sonnet | Git operations with conventional commits | Phase 6-8 |
| `journal-writer` | Sonnet | Technical failure documentation and session journals | Phase 9 |

---

## 3. Complete Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                      PRODUCT BRIEF                                           │
│                                    (User Input)                                              │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 1: VALIDATION                                                                         │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐    │
│  │                         product-brief-analyst (Opus)                                 │    │
│  │  • Validates completeness against checklist                                          │    │
│  │  • Identifies ambiguities and contradictions                                         │    │
│  │  • Extracts implicit requirements                                                    │    │
│  │  • Outputs: Validated, structured brief                                              │    │
│  └─────────────────────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 2: SPECIFICATION                                                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐    │
│  │                          tech-spec-architect (Opus)                                  │    │
│  │  • Creates comprehensive technical specifications                                    │    │
│  │  • Database schemas, API contracts, architecture patterns                            │    │
│  │  • Outputs: frontend-spec.md, backend-spec.md, repo-structure.md                     │    │
│  └─────────────────────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 3: PLANNING (Parallel)                                                                │
│  ┌────────────────────────────────┐         ┌────────────────────────────────┐              │
│  │  implementation-planner (Opus) │         │  implementation-planner (Opus) │              │
│  │  Input: frontend-spec.md       │         │  Input: backend-spec.md        │              │
│  │  Output: frontend-*.md plan    │         │  Output: backend-*.md plan     │              │
│  └────────────────────────────────┘         └────────────────────────────────┘              │
│                    │                                       │                                 │
│                    └───────────────┬───────────────────────┘                                 │
│                                    │                                                         │
│                    ┌───────────────┴───────────────┐                                         │
│                    │  devops-engineer (Sonnet)     │                                         │
│                    │  Input: Both specs            │                                         │
│                    │  Output: infrastructure plan  │                                         │
│                    └───────────────────────────────┘                                         │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 4: CONTRACT GENERATION                                                                │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐    │
│  │                          contract-generator (Sonnet)                                 │    │
│  │  • Reads contract requirements from all plans                                        │    │
│  │  • Detects tech stack automatically                                                  │    │
│  │  • Generates: TypeScript interfaces, OpenAPI specs, Pydantic models, etc.            │    │
│  │  • Creates mock implementations for testing                                          │    │
│  └─────────────────────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 5: TEST SPECIFICATION (Parallel with Phase 4)                                         │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐    │
│  │                          test-spec-generator (Opus)                                  │    │
│  │  • Creates comprehensive test strategies                                             │    │
│  │  • Unit, integration, E2E, performance, security, accessibility                      │    │
│  │  • Maps testing tools per detected stack                                             │    │
│  └─────────────────────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
╔═════════════════════════════════════════════════════════════════════════════════════════════╗
║  PHASE 6: ORCHESTRATED IMPLEMENTATION                                                        ║
║                                                                                              ║
║  ┌─────────────────────────────────────────────────────────────────────────────────────┐    ║
║  │                         /task-orchestration (Skill)                                  │    ║
║  │                                                                                      │    ║
║  │  1. Parse plans from .claude/plans/                                                  │    ║
║  │  2. Create task graph with dependencies                                              │    ║
║  │  3. Dispatch waves of parallel work                                                  │    ║
║  │  4. Monitor completion, dispatch next wave                                           │    ║
║  └─────────────────────────────────────────────────────────────────────────────────────┘    ║
║                                            │                                                 ║
║              ┌─────────────────────────────┼─────────────────────────────┐                   ║
║              │                             │                             │                   ║
║              ▼                             ▼                             ▼                   ║
║  ┌───────────────────────┐   ┌───────────────────────┐   ┌───────────────────────┐          ║
║  │ Wave 0: Foundation    │   │ Wave 1: Infrastructure│   │ Wave 2: Features      │          ║
║  │ (Sequential)          │   │ (Parallel)            │   │ (Parallel)            │          ║
║  │                       │   │                       │   │                       │          ║
║  │ • DB migrations       │   │ • API scaffolding     │   │ • Backend services    │          ║
║  │ • Auth setup          │   │ • Data access layer   │   │ • Frontend components │          ║
║  │ • Core config         │   │ • External clients    │   │ • State management    │          ║
║  │                       │   │ • CI/CD pipeline      │   │ • API integration     │          ║
║  │ Agents:               │   │                       │   │                       │          ║
║  │ • db-migration-spec   │   │ Agents:               │   │ Agents:               │          ║
║  │ • senior-backend-eng  │   │ • senior-backend-eng  │   │ • senior-backend-eng  │          ║
║  │                       │   │ • senior-frontend-eng │   │ • senior-frontend-eng │          ║
║  │                       │   │ • devops-engineer     │   │ • devops-engineer     │          ║
║  └───────────────────────┘   └───────────────────────┘   └───────────────────────┘          ║
║              │                             │                             │                   ║
║              └─────────────────────────────┼─────────────────────────────┘                   ║
║                                            │                                                 ║
║                                            ▼                                                 ║
║                              ┌───────────────────────┐                                       ║
║                              │ Wave 3: Integration   │                                       ║
║                              │ (Coordinated)         │                                       ║
║                              │                       │                                       ║
║                              │ • Cross-feature flows │                                       ║
║                              │ • End-to-end paths    │                                       ║
║                              │ • Performance tuning  │                                       ║
║                              └───────────────────────┘                                       ║
╚═════════════════════════════════════════════════════════════════════════════════════════════╝
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 7: CODE REVIEW                                                                        │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐    │
│  │                            code-reviewer (Opus)                                      │    │
│  │  • Reviews all implementation for quality, security, performance                     │    │
│  │  • Checks architectural consistency                                                  │    │
│  │  • Identifies anti-patterns and violations                                           │    │
│  │  • Outputs: Review report with Blocker/Critical/Major/Minor issues                   │    │
│  └─────────────────────────────────────────────────────────────────────────────────────┘    │
│                                            │                                                 │
│                          ┌─────────────────┴─────────────────┐                               │
│                          │                                   │                               │
│                    Issues Found?                        No Issues                            │
│                          │                                   │                               │
│                          ▼                                   ▼                               │
│              ┌───────────────────────┐            Continue to Phase 8                        │
│              │  REVIEW FIX LOOP      │                                                       │
│              │  Route to appropriate │                                                       │
│              │  engineer agent       │                                                       │
│              │  (see Section 6)      │                                                       │
│              └───────────────────────┘                                                       │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 8: TESTING (Parallel with Feedback Loop)                                              │
│                                                                                              │
│  ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐        │
│  │ integration-test │ │ e2e-test-        │ │ security-test-   │ │ performance-test │        │
│  │ -executor        │ │ executor         │ │ executor         │ │ -executor        │        │
│  │                  │ │                  │ │                  │ │                  │        │
│  │ • API contracts  │ │ • User flows     │ │ • SAST/DAST      │ │ • Load tests     │        │
│  │ • DB integration │ │ • Cross-browser  │ │ • Dependency     │ │ • Stress tests   │        │
│  │ • Cache tests    │ │ • Mobile         │ │   scanning       │ │ • Latency        │        │
│  │ • Queue tests    │ │                  │ │ • OWASP Top 10   │ │   analysis       │        │
│  └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘        │
│           │                    │                    │                    │                   │
│           └────────────────────┴────────────────────┴────────────────────┘                   │
│                                            │                                                 │
│                                ┌───────────┴───────────┐                                     │
│                                │ accessibility-test-   │                                     │
│                                │ executor              │                                     │
│                                │                       │                                     │
│                                │ • WCAG 2.1/2.2        │                                     │
│                                │ • axe-core            │                                     │
│                                │ • Keyboard nav        │                                     │
│                                └───────────┬───────────┘                                     │
│                                            │                                                 │
│                          ┌─────────────────┴─────────────────┐                               │
│                          │                                   │                               │
│                    Tests Failed?                       All Tests Pass                        │
│                          │                                   │                               │
│                          ▼                                   ▼                               │
│              ┌───────────────────────┐            Continue to Phase 9                        │
│              │  TEST FIX LOOP        │                                                       │
│              │  (see Section 6)      │◄──────────────────────────────────────────────────┐   │
│              │                       │                                                   │   │
│              │  Orchestrator routes  │                                                   │   │
│              │  failures to correct  │───────────► Engineer Fixes ───────► Re-run Tests─┘   │
│              │  engineer agent       │                                                       │
│              └───────────────────────┘                                                       │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 9: DOCUMENTATION & OBSERVABILITY (Parallel)                                           │
│                                                                                              │
│  ┌─────────────────────────────────────┐   ┌─────────────────────────────────────┐          │
│  │    documentation-generator          │   │    observability-engineer           │          │
│  │                                     │   │                                     │          │
│  │  • API documentation                │   │  • Structured logging               │          │
│  │  • README files                     │   │  • Metrics & dashboards             │          │
│  │  • Architecture Decision Records    │   │  • Distributed tracing              │          │
│  │  • Deployment guides                │   │  • Alerting rules                   │          │
│  │  • User guides                      │   │  • Health checks                    │          │
│  └─────────────────────────────────────┘   └─────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│  PHASE 10: REFINEMENT (Conditional)                                                          │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐    │
│  │                            code-simplifier (Opus)                                    │    │
│  │  • Applied when code complexity is flagged                                           │    │
│  │  • Focuses on recently modified files                                                │    │
│  │  • Preserves functionality while improving clarity                                   │    │
│  └─────────────────────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                    PRODUCTION READY                                          │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Phase Breakdown

### Phase 1: Product Brief Validation

**Agent:** `product-brief-analyst`
**Model:** Opus
**Duration:** Single pass
**Dependencies:** None (entry point)

**Purpose:**
Validates and structures raw product briefs before they enter the specification phase. Catches ambiguities, contradictions, and missing requirements early.

**Inputs:**
- Raw product brief (text, document, or conversation)

**Outputs:**
- Validated product brief with:
  - Structured requirements
  - Identified ambiguities flagged
  - Open questions for stakeholders
  - Assumptions documented

**Quality Gates:**
- [ ] All sections complete
- [ ] No critical ambiguities remaining
- [ ] Success metrics defined
- [ ] User personas identified

---

### Phase 2: Technical Specification

**Agent:** `tech-spec-architect`
**Model:** Opus
**Duration:** Single pass
**Dependencies:** Phase 1 complete

**Purpose:**
Creates comprehensive, implementation-ready technical specifications.

**Inputs:**
- Validated product brief

**Outputs:**
- `frontend-spec.md` - Frontend architecture and components
- `backend-spec.md` - Backend services and APIs
- `repo-structure.md` - Project structure and organization

**Quality Gates:**
- [ ] All sections complete (no TODOs)
- [ ] Code examples compile
- [ ] Database schemas normalized
- [ ] API contracts consistent

---

### Phase 3: Implementation Planning

**Agents:** `implementation-planner` (×2), `devops-engineer`
**Model:** Opus, Sonnet
**Duration:** Parallel execution
**Dependencies:** Phase 2 complete

**Purpose:**
Transforms specifications into parallelizable execution plans.

**Inputs:**
- Technical specifications (frontend-spec.md, backend-spec.md)

**Outputs:**
- `.claude/plans/frontend-*.md` - Frontend implementation plan
- `.claude/plans/backend-*.md` - Backend implementation plan
- `.claude/plans/infrastructure-*.md` - DevOps/infrastructure plan
- Contract requirements catalog (not actual contracts)

**Quality Gates:**
- [ ] All work units follow SPARK principles
- [ ] Dependencies clearly mapped
- [ ] Maximum parallelism identified
- [ ] Contract requirements documented

---

### Phase 4: Contract Generation

**Agent:** `contract-generator`
**Model:** Sonnet
**Duration:** Single pass
**Dependencies:** Phase 3 complete

**Purpose:**
Generates interface contracts that enable parallel development.

**Inputs:**
- Contract requirements from implementation plans
- Detected tech stack

**Outputs (varies by stack):**
- TypeScript: `.ts` interface files
- Python: Protocol/Pydantic model files
- OpenAPI: `openapi.yaml` specifications
- JSON Schema files
- Mock implementations

**Quality Gates:**
- [ ] All required contracts generated
- [ ] Contracts match detected tech stack
- [ ] Mock implementations provided
- [ ] Contracts validated syntactically

---

### Phase 5: Test Specification

**Agent:** `test-spec-generator`
**Model:** Opus
**Duration:** Parallel with Phase 4
**Dependencies:** Phase 2 complete

**Purpose:**
Creates comprehensive test strategies before implementation.

**Inputs:**
- Technical specifications
- Implementation plans

**Outputs:**
- Test specification document with:
  - Unit test strategies
  - Integration test strategies
  - E2E test scenarios
  - Performance test plans
  - Security test requirements
  - Accessibility test requirements

**Quality Gates:**
- [ ] Coverage for all critical paths
- [ ] Test pyramid defined
- [ ] Testing tools mapped to stack

---

### Phase 6: Orchestrated Implementation

**Skill:** `/task-orchestration`
**Agents:** Multiple (dispatched by orchestrator)
**Duration:** Wave-based execution
**Dependencies:** Phases 4 and 5 complete

**Purpose:**
Coordinates parallel implementation across specialized agents.

**How It Works:**

1. **Initialization:**
   ```
   Orchestrator reads .claude/plans/*.md
   → Parses work units and dependencies
   → Creates task graph
   → Identifies Wave 0 (foundation) tasks
   ```

2. **Wave Execution:**
   ```
   For each wave:
     → Dispatch all ready units in parallel
     → Each unit → Appropriate sub-agent
     → Await completion
     → Mark complete, unblock dependents
     → Dispatch newly ready units
   ```

3. **Sub-Agent Dispatch Rules:**

   | Work Unit Type | Dispatched To |
   |----------------|---------------|
   | Database Schema | `senior-backend-engineer` |
   | Database Migrations | `database-migration-specialist` |
   | API/Services | `senior-backend-engineer` |
   | Authentication | `senior-backend-engineer` |
   | UI Components | `senior-frontend-engineer` |
   | State Management | `senior-frontend-engineer` |
   | Containerization | `devops-engineer` |
   | CI/CD Pipeline | `devops-engineer` |

**Quality Gates:**
- [ ] All units complete
- [ ] No blocking dependencies remaining
- [ ] Contracts respected

---

### Phase 7: Code Review

**Agent:** `code-reviewer`
**Model:** Opus
**Duration:** Single pass per review cycle
**Dependencies:** Phase 6 complete

**Purpose:**
Quality gate before testing to catch issues early.

**Inputs:**
- All implemented code from Phase 6

**Outputs:**
- Review report with:
  - Blocker issues (must fix)
  - Critical issues (should fix)
  - Major issues (important)
  - Minor issues (nice to have)
  - Security checklist results
  - Performance considerations

**Feedback Loop:**
If issues found → Route to appropriate engineer → Re-review

---

### Phase 8: Testing

**Agents:** All test executors (parallel)
**Model:** Sonnet
**Duration:** Parallel execution with feedback loop
**Dependencies:** Phase 7 complete (no blockers)

**Purpose:**
Comprehensive quality assurance with automatic fix routing.

**Test Executor Matrix:**

| Agent | Test Type | Focus Areas |
|-------|-----------|-------------|
| `integration-test-executor` | Integration | API contracts, DB, cache, queues |
| `e2e-test-executor` | End-to-End | User flows, cross-browser |
| `security-test-executor` | Security | SAST, DAST, OWASP, dependencies |
| `performance-test-executor` | Performance | Load, stress, latency |
| `accessibility-test-executor` | Accessibility | WCAG, keyboard, screen readers |

**Feedback Loop:**
See Section 6 for detailed fix routing.

---

### Phase 9: Documentation & Observability

**Agents:** `documentation-generator`, `observability-engineer`
**Model:** Sonnet
**Duration:** Parallel execution
**Dependencies:** Phase 8 complete (all tests pass)

**Purpose:**
Production readiness: documentation and monitoring.

**Documentation Outputs:**
- API documentation
- README files
- Architecture Decision Records (ADRs)
- Deployment guides
- User guides

**Observability Outputs:**
- Logging configuration
- Metrics and dashboards
- Distributed tracing setup
- Alerting rules
- Health check endpoints

---

### Phase 10: Refinement

**Agent:** `code-simplifier`
**Model:** Opus
**Duration:** Conditional
**Dependencies:** Phase 9 complete

**Purpose:**
Optional code clarity improvements.

**Trigger Conditions:**
- Code complexity flagged during review
- Test coverage indicates complex paths
- Explicit user request

**Focus:**
- Recently modified files
- High-complexity functions
- Duplicated patterns

---

## 5. Task Orchestration

### 5.1 When Task Orchestration Activates

The `/task-orchestration` skill activates when:

1. **Implementation plans exist** in `.claude/plans/`
2. **Multiple work units** need coordination
3. **User invokes** `/task-orchestration`

### 5.2 Orchestration State Management

```
┌────────────────────────────────────────────────────────────────┐
│                    Task System Integration                      │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  TaskCreate    → Initialize work units from plan               │
│  TaskUpdate    → Update status, set dependencies               │
│  TaskList      → View all units and state                      │
│  TaskGet       → Get full unit details                         │
│                                                                │
│  Task Metadata:                                                │
│  {                                                             │
│    "wave": 0,                                                  │
│    "unitId": "UNIT-01",                                        │
│    "agentType": "senior-backend-engineer",                     │
│    "status": "pending" | "in_progress" | "completed"           │
│  }                                                             │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 5.3 Dispatch Rules

A unit is **ready for dispatch** when:
- Status is `pending`
- `blockedBy` list is empty (all dependencies resolved)

Dispatch process:
1. Mark unit `in_progress` via `TaskUpdate`
2. Spawn sub-agent via `Task` tool with unit description
3. Dispatch **ALL** ready units simultaneously (parallel `Task` calls)

### 5.4 Progress Reporting

After each wave transition:

```markdown
## Orchestration Progress

Wave: 2 of 4
Completed: 8 / 15 units

Active:
- UNIT-09 → senior-backend-engineer
- UNIT-10 → senior-frontend-engineer
- UNIT-11 → devops-engineer

Ready to Dispatch:
- UNIT-12, UNIT-13

Waiting:
- UNIT-14 (blocked by UNIT-09)
- UNIT-15 (blocked by UNIT-10, UNIT-11)
```

---

## 6. Feedback Loop: Test-Fix Cycle

### 6.1 Overview

When any testing agent discovers failures, the orchestrator routes the issues back to the appropriate engineer agent for fixes. This cycle continues until all tests pass.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           TEST-FIX FEEDBACK LOOP                             │
│                                                                              │
│    ┌──────────────┐                                                          │
│    │  Test Agent  │                                                          │
│    │  Executes    │                                                          │
│    └──────┬───────┘                                                          │
│           │                                                                  │
│           ▼                                                                  │
│    ┌──────────────┐     Pass      ┌──────────────┐                          │
│    │   Results    │──────────────►│   Continue   │                          │
│    │   Analysis   │               │   to Next    │                          │
│    └──────┬───────┘               │   Phase      │                          │
│           │                       └──────────────┘                          │
│           │ Fail                                                             │
│           ▼                                                                  │
│    ┌──────────────┐                                                          │
│    │   Generate   │                                                          │
│    │   Failure    │                                                          │
│    │   Report     │                                                          │
│    └──────┬───────┘                                                          │
│           │                                                                  │
│           ▼                                                                  │
│    ┌──────────────┐                                                          │
│    │   Classify   │                                                          │
│    │   Failure    │                                                          │
│    │   Type       │                                                          │
│    └──────┬───────┘                                                          │
│           │                                                                  │
│           ├──────────────────────────────────────────────────────┐           │
│           │                                                      │           │
│           ▼                                                      ▼           │
│    ┌──────────────┐                                       ┌──────────────┐   │
│    │   Backend    │                                       │   Frontend   │   │
│    │   Failure?   │                                       │   Failure?   │   │
│    └──────┬───────┘                                       └──────┬───────┘   │
│           │ Yes                                                  │ Yes       │
│           ▼                                                      ▼           │
│    ┌──────────────┐                                       ┌──────────────┐   │
│    │   Route to   │                                       │   Route to   │   │
│    │   senior-    │                                       │   senior-    │   │
│    │   backend-   │                                       │   frontend-  │   │
│    │   engineer   │                                       │   engineer   │   │
│    └──────┬───────┘                                       └──────┬───────┘   │
│           │                                                      │           │
│           └──────────────────────┬───────────────────────────────┘           │
│                                  │                                           │
│                                  ▼                                           │
│                           ┌──────────────┐                                   │
│                           │   Engineer   │                                   │
│                           │   Applies    │                                   │
│                           │   Fix        │                                   │
│                           └──────┬───────┘                                   │
│                                  │                                           │
│                                  ▼                                           │
│                           ┌──────────────┐                                   │
│                           │   Re-run     │                                   │
│                           │   Failed     │◄──────────────────────────────────┤
│                           │   Tests      │                                   │
│                           └──────┬───────┘                                   │
│                                  │                                           │
│                                  └──────────► Loop until all tests pass      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 6.2 Failure Classification & Routing

| Failure Type | Indicators | Routed To |
|--------------|------------|-----------|
| **Backend API** | HTTP errors, API contract violations, service errors | `senior-backend-engineer` |
| **Database** | Query failures, constraint violations, migration issues | `database-migration-specialist` |
| **Frontend UI** | Component errors, rendering issues, state bugs | `senior-frontend-engineer` |
| **Integration** | Service communication, contract mismatches | `senior-backend-engineer` + `senior-frontend-engineer` |
| **Infrastructure** | Container, deployment, CI/CD failures | `devops-engineer` |
| **Security** | Vulnerabilities, auth issues, injection flaws | `senior-backend-engineer` (with security context) |
| **Performance** | Latency, throughput, resource issues | Original implementer + `observability-engineer` |
| **Accessibility** | WCAG violations, keyboard nav, screen reader | `senior-frontend-engineer` |

### 6.3 Fix Request Format

When routing a failure to an engineer, the orchestrator provides:

```markdown
## Fix Request

**Test Agent:** e2e-test-executor
**Test Type:** End-to-End
**Failure Count:** 3

### Failed Test 1: test_user_login_flow

**File:** `tests/e2e/auth/login.spec.ts:45`
**Error:**
```
TimeoutError: Waiting for selector "#login-button" exceeded 30000ms
```

**Root Cause Analysis:**
Login button not rendered due to missing authentication state initialization.

**Affected Files:**
- `src/components/auth/LoginForm.tsx`
- `src/stores/authStore.ts`

**Suggested Fix:**
Initialize auth state before rendering login form:
```typescript
// In LoginForm.tsx
useEffect(() => {
  authStore.initialize();
}, []);
```

### Failed Test 2: ...

---

**Instructions:**
1. Apply fixes to all affected files
2. Run related unit tests to verify
3. Signal completion for re-test
```

### 6.4 Fix Verification Process

```
┌─────────────────────────────────────────────────────────────────┐
│                    FIX VERIFICATION PROCESS                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Engineer receives fix request                               │
│     └── Includes: error, analysis, affected files, suggestion   │
│                                                                 │
│  2. Engineer applies fix                                        │
│     └── Modifies relevant files                                 │
│     └── Runs local unit tests                                   │
│                                                                 │
│  3. Engineer signals completion                                 │
│     └── TaskUpdate: status = "fix_applied"                      │
│     └── Provides summary of changes                             │
│                                                                 │
│  4. Orchestrator triggers re-test                               │
│     └── Only failed tests re-run (not full suite)               │
│     └── Same test agent that found the failure                  │
│                                                                 │
│  5. Results evaluated                                           │
│     ├── Pass → Mark resolved, continue                          │
│     └── Fail → Loop back to step 1 with new analysis            │
│                                                                 │
│  6. After 3 failed fix attempts:                                │
│     └── Escalate to human review                                │
│     └── Provide full context and attempted fixes                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 6.5 Parallel Fix Handling

When multiple test agents find failures simultaneously:

```
┌─────────────────────────────────────────────────────────────────┐
│                    PARALLEL FIX COORDINATION                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Test Results (Parallel):                                       │
│  ├── integration-test-executor: 2 failures (backend)            │
│  ├── e2e-test-executor: 3 failures (frontend)                   │
│  ├── security-test-executor: 1 failure (backend)                │
│  └── accessibility-test-executor: 2 failures (frontend)         │
│                                                                 │
│  Orchestrator Consolidation:                                    │
│  ├── Backend failures: 3 total → senior-backend-engineer        │
│  └── Frontend failures: 5 total → senior-frontend-engineer      │
│                                                                 │
│  Parallel Fix Dispatch:                                         │
│  ├── senior-backend-engineer (3 issues in single request)       │
│  └── senior-frontend-engineer (5 issues in single request)      │
│                                                                 │
│  After fixes applied:                                           │
│  └── Re-run ALL failed tests in parallel                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 6.6 Fix Loop Safeguards

To prevent infinite loops:

1. **Max Iterations:** 5 fix attempts per test
2. **Escalation:** After 3 failures, flag for human review
3. **Timeout:** Max 30 minutes per fix cycle
4. **Dependency Check:** If fix introduces new failures, analyze root cause
5. **Rollback Option:** If fixes destabilize, revert and escalate

---

## 7. Execution Examples

### 7.1 Example: Simple Feature Addition

**Input:** "Add a user settings page"

```
Phase 1: product-brief-analyst
└── Validates: What settings? User preferences? Account management?

Phase 2: tech-spec-architect
└── Creates: UI spec, API endpoints, database fields

Phase 3: implementation-planner (parallel)
├── frontend plan: SettingsPage component, form state
└── backend plan: /api/settings endpoints, User model update

Phase 4: contract-generator
└── Generates: SettingsRequest/Response types, API schema

Phase 5: test-spec-generator
└── Creates: Unit tests for form, API tests, E2E settings flow

Phase 6: /task-orchestration
├── Wave 0: Database migration (add settings fields)
├── Wave 1: Backend API + Frontend component (parallel)
└── Wave 2: Integration (connect frontend to backend)

Phase 7: code-reviewer
└── Reviews all changes

Phase 8: Testing (parallel)
├── integration-test-executor: API tests
├── e2e-test-executor: Settings page flow
└── accessibility-test-executor: Form accessibility

Phase 9: documentation-generator
└── Updates API docs, adds settings guide
```

### 7.2 Example: Fix Loop in Action

**Scenario:** E2E test finds login button not clickable

```
1. e2e-test-executor runs tests
   └── FAIL: test_user_can_login
       └── Error: Element #login-btn not interactable

2. Orchestrator analyzes failure
   └── Classification: Frontend UI issue
   └── Affected file: src/components/LoginButton.tsx

3. Route to senior-frontend-engineer
   └── Fix request with error, analysis, suggested fix

4. senior-frontend-engineer applies fix
   └── Adds proper loading state handling
   └── Runs local unit tests: PASS

5. Orchestrator triggers re-test
   └── e2e-test-executor re-runs test_user_can_login

6. Result: PASS
   └── Mark resolved, continue to next phase
```

### 7.3 Example: Complex Multi-Agent Fix

**Scenario:** Integration tests reveal API contract mismatch

```
1. integration-test-executor runs tests
   └── FAIL: test_create_order_api
       └── Error: Response missing 'total' field

2. Orchestrator analyzes failure
   └── Classification: Contract mismatch (backend + frontend)
   └── Root cause: Backend changed response, frontend expects old format

3. Route to BOTH agents (parallel)
   ├── senior-backend-engineer: Update API to include 'total'
   └── senior-frontend-engineer: Handle both formats (backward compat)

4. Both engineers apply fixes
   └── Backend adds 'total' field
   └── Frontend handles presence/absence gracefully

5. Orchestrator triggers re-test
   └── integration-test-executor re-runs test_create_order_api

6. Result: PASS
   └── Contract now aligned
```

---

## 8. Best Practices

### 8.1 For Optimal Parallel Execution

1. **Define contracts early** - Phase 4 is critical for parallelism
2. **Keep units small** - Smaller units = more parallelism
3. **Minimize dependencies** - Challenge every hard dependency
4. **Use interface contracts** - Soft dependencies can run in parallel

### 8.2 For Efficient Fix Loops

1. **Provide context** - Include full error, affected files, suggested fix
2. **Run targeted re-tests** - Only failed tests, not full suite
3. **Consolidate fixes** - Group multiple failures for same engineer
4. **Set iteration limits** - Prevent infinite loops

### 8.3 For Quality Gates

1. **Code review before testing** - Catch obvious issues early
2. **Parallel test execution** - All test types simultaneously
3. **Fail fast** - Stop on blockers, continue on warnings
4. **Document decisions** - ADRs for architectural choices

### 8.4 For Agent Selection

| Task Complexity | Recommended Model |
|-----------------|-------------------|
| Analysis, planning, review | Opus |
| Implementation, testing | Sonnet |
| Simple queries | Haiku |

---

## 9. Toolkit Integration

The SDLC is enhanced with skills, commands, hooks, and rules from the integrated toolkit. These components automate quality gates, provide developer shortcuts, and enforce consistency across all phases.

### 9.1 Skills by SDLC Phase

| Skill | SDLC Phase | Purpose |
|-------|-----------|---------|
| `planning` | Phase 2-3 | Structured research→plan workflow |
| `cook` | Phase 6 | Plan→implement→test→review workflow |
| `test` | Phase 5, 8 | Multi-framework test execution (Jest/Vitest/pytest/etc.) |
| `debug` | Phase 8 | Systematic debugging for test-fix feedback loop |
| `code-review` | Phase 7 | Structured review with edge case detection |
| `git` | Phase 6-8 | Conventional commits, PR workflow |
| `fix` | Phase 8 | Issue routing and fix verification |
| `task-orchestration` | Phase 6 | Task state management and dispatch (pre-existing) |

### 9.2 Slash Commands by Workflow

**Planning:**
- `/plan` — Start structured planning workflow
- `/plan:fast` — Quick planning for small features
- `/plan:hard` — Deep planning for complex features
- `/plan:parallel` — Parallel planning with multiple research threads

**Implementation:**
- `/cook` — Plan→implement→test→review workflow
- `/cook:auto` — Automated cooking with minimal prompts
- `/cook:auto:parallel` — Parallel automated cooking

**Testing & Fixing:**
- `/test` — Run test suites
- `/fix` — Intelligent issue routing
- `/fix:test` — Fix test failures
- `/fix:fast` — Quick fixes
- `/fix:hard` — Deep investigation fixes
- `/fix:parallel` — Parallel fix execution
- `/fix:ci` — Fix CI pipeline failures
- `/debug` — Systematic debugging

**Code Quality:**
- `/review:codebase` — Comprehensive codebase review

**Git & Project:**
- `/git:cm` — Conventional commit creation
- `/git:pr` — Pull request creation
- `/kanban` — Project task board overview

### 9.3 Hook-Enforced Quality Gates

| Hook | Event | Purpose |
|------|-------|---------|
| `session-init.cjs` | SessionStart | Project detection, environment setup |
| `dev-rules-reminder.cjs` | UserPromptSubmit | Inject development rules context |
| `scout-block.cjs` | PreToolUse | Block access to node_modules/.git directories |
| `privacy-block.cjs` | PreToolUse | Block access to .env/credentials files |
| `modularization-hook.js` | PostToolUse | Suggest splitting files exceeding 200 LOC |
| `subagent-init.cjs` | SubagentStart | Context injection for sub-agents |

### 9.4 Rules Reference

All agents must follow these rules when applicable:

| Rule File | Scope | Key Standards |
|-----------|-------|---------------|
| `rules/development-rules.md` | All implementation agents | YAGNI/KISS/DRY, <200 LOC files, kebab-case naming, testing, security, conventional commits |
| `rules/orchestration-protocol.md` | Orchestrator, planners | Subagent delegation patterns, sequential chaining, parallel execution, context passing |
| `rules/documentation-management.md` | Documentation agents | Evidence-based docs, <800 LOC, code-to-doc sync |

---

## Appendix A: Agent Invocation Quick Reference

```bash
# Phase 1: Validate product brief
Task → product-brief-analyst → "Validate this product brief: [brief]"

# Phase 2: Create specifications
Task → tech-spec-architect → "Create technical specs for: [validated brief]"

# Phase 3: Plan implementation
Task → implementation-planner → "Create implementation plan for: [spec file]"
Task → devops-engineer → "Create infrastructure plan for: [spec files]"

# Phase 4: Generate contracts
Task → contract-generator → "Generate contracts from: [plan files]"

# Phase 5: Create test specs
Task → test-spec-generator → "Create test specifications for: [specs]"

# Phase 6: Orchestrated implementation
Skill → /task-orchestration

# Phase 7: Code review
Task → code-reviewer → "Review implementation in: [paths]"

# Phase 8: Execute tests (parallel)
Task → integration-test-executor → "Run integration tests"
Task → e2e-test-executor → "Run E2E tests"
Task → security-test-executor → "Run security tests"
Task → performance-test-executor → "Run performance tests"
Task → accessibility-test-executor → "Run accessibility tests"

# Phase 9: Documentation (parallel)
Task → documentation-generator → "Generate documentation for: [project]"
Task → observability-engineer → "Set up observability for: [project]"

# Phase 10: Refinement (conditional)
Task → code-simplifier → "Simplify code in: [paths]"
```

---

## Appendix B: Failure Routing Matrix

| Test Agent | Failure Type | Primary Route | Secondary Route |
|------------|--------------|---------------|-----------------|
| integration-test-executor | API contract | senior-backend-engineer | contract-generator |
| integration-test-executor | Database | database-migration-specialist | senior-backend-engineer |
| integration-test-executor | Cache | senior-backend-engineer | - |
| e2e-test-executor | UI interaction | senior-frontend-engineer | - |
| e2e-test-executor | API call | senior-backend-engineer | senior-frontend-engineer |
| security-test-executor | Auth/authz | senior-backend-engineer | - |
| security-test-executor | Injection | senior-backend-engineer | - |
| security-test-executor | Dependencies | devops-engineer | - |
| performance-test-executor | Latency | senior-backend-engineer | observability-engineer |
| performance-test-executor | Throughput | senior-backend-engineer | devops-engineer |
| accessibility-test-executor | WCAG | senior-frontend-engineer | - |

---

**Document End**
