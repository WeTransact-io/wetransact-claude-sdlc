# Agent Output Directory Structure

**Version:** 1.0.0
**Last Updated:** 2026-02-04
**Purpose:** Centralized location for all agent-generated artifacts

---

## Overview

This document defines the standardized directory structure where all sub-agents write their output files. This centralization enables:

- **Discoverability**: Easy to find agent outputs
- **Organization**: Logical grouping by SDLC phase
- **Version Control**: Track changes to generated artifacts
- **Orchestration**: Other agents can reference standard locations
- **Cleanup**: Easy to identify generated vs. hand-written files

---

## Directory Structure

```
.claude/
├── output/
│   ├── briefs/              # Product brief validation outputs
│   │   ├── validated/       # Validated and structured product briefs
│   │   └── analysis/        # Analysis reports and findings
│   │
│   ├── specs/               # Technical specifications
│   │   ├── frontend/        # Frontend technical specs
│   │   ├── backend/         # Backend technical specs
│   │   ├── infrastructure/  # Infrastructure/DevOps specs
│   │   ├── database/        # Database schema specifications
│   │   └── architecture/    # System architecture documents
│   │
│   ├── plans/               # Implementation plans (existing)
│   │   └── *.md             # Feature implementation plans
│   │
│   ├── contracts/           # Interface contracts
│   │   ├── api/             # API contracts (OpenAPI, AsyncAPI)
│   │   ├── services/        # Service interface contracts
│   │   ├── components/      # Component contracts (props, events)
│   │   ├── schemas/         # Data schemas and DTOs
│   │   └── events/          # Event/message contracts
│   │
│   ├── tests/               # Test specifications and reports
│   │   ├── specs/           # Test strategy documents
│   │   ├── reports/         # Test execution reports
│   │   │   ├── unit/
│   │   │   ├── integration/
│   │   │   ├── e2e/
│   │   │   ├── security/
│   │   │   ├── performance/
│   │   │   └── accessibility/
│   │   └── coverage/        # Coverage reports
│   │
│   ├── reviews/             # Code review reports
│   │   ├── initial/         # Initial review findings
│   │   ├── fixes/           # Fix verification reports
│   │   └── final/           # Final approval reports
│   │
│   ├── implementation/      # Implementation summaries
│   │   ├── backend/         # Backend implementation summaries
│   │   ├── frontend/        # Frontend implementation summaries
│   │   ├── devops/          # DevOps implementation summaries
│   │   └── database/        # Database migration summaries
│   │
│   └── docs/                # Generated documentation
│       ├── api/             # API documentation
│       ├── architecture/    # ADRs and architecture docs
│       ├── deployment/      # Deployment guides
│       ├── guides/          # User and developer guides
│       └── observability/   # Monitoring and logging docs
```

---

## Agent Output Mapping

| Agent | Primary Output Directory | File Naming Convention |
|-------|-------------------------|------------------------|
| `product-brief-analyst` | `.claude/output/briefs/validated/` | `<project-name>-validated-brief-<date>.md` |
| `tech-spec-architect` | `.claude/output/specs/` | `<layer>-spec-<feature>-<date>.md` |
| `implementation-planner` | `.claude/plans/` (existing) | `<domain>-<feature>-plan.md` |
| `contract-generator` | `.claude/output/contracts/` | `<contract-type>/<name>.<ext>` |
| `test-spec-generator` | `.claude/output/tests/specs/` | `test-spec-<project>-<date>.md` |
| `integration-test-executor` | `.claude/output/tests/reports/integration/` | `integration-report-<date>.md` |
| `e2e-test-executor` | `.claude/output/tests/reports/e2e/` | `e2e-report-<date>.md` |
| `security-test-executor` | `.claude/output/tests/reports/security/` | `security-report-<date>.md` |
| `performance-test-executor` | `.claude/output/tests/reports/performance/` | `performance-report-<date>.md` |
| `accessibility-test-executor` | `.claude/output/tests/reports/accessibility/` | `accessibility-report-<date>.md` |
| `code-reviewer` | `.claude/output/reviews/` | `review-<scope>-<date>.md` |
| `senior-backend-engineer` | `.claude/output/implementation/backend/` | `backend-impl-<feature>-<date>.md` |
| `senior-frontend-engineer` | `.claude/output/implementation/frontend/` | `frontend-impl-<feature>-<date>.md` |
| `devops-engineer` | `.claude/output/implementation/devops/` | `devops-impl-<feature>-<date>.md` |
| `database-migration-specialist` | `.claude/output/implementation/database/` | `database-impl-<feature>-<date>.md` |
| `documentation-generator` | `.claude/output/docs/` | Varies by doc type |
| `observability-engineer` | `.claude/output/docs/observability/` | `<monitoring-aspect>-config.md` |
| `debugger` | `.claude/output/tests/reports/` | `debug-report-<issue>-<date>.md` |
| `git-manager` | N/A (git operations only) | N/A |

---

## File Naming Conventions

### General Rules

1. Use **kebab-case** for all filenames
2. Include **date** in format `YYYY-MM-DD` for versioned outputs
3. Use **descriptive names** that indicate content
4. Include **layer/domain** prefix when relevant

### Examples

**Product Briefs:**
- `messenger-app-validated-brief-2026-02-04.md`
- `user-authentication-analysis-2026-02-04.md`

**Technical Specifications:**
- `frontend-spec-chat-interface-2026-02-04.md`
- `backend-spec-message-streaming-2026-02-04.md`
- `database-spec-message-storage-2026-02-04.md`

**Implementation Plans:**
- `frontend-chat-ui-plan.md`
- `backend-websocket-api-plan.md`
- `infrastructure-deployment-plan.md`

**Contracts:**
- `api/message-api-v1.openapi.yaml`
- `services/IMessageService.ts`
- `components/ChatInputProps.ts`
- `schemas/Message.schema.json`
- `events/MessageCreatedEvent.asyncapi.yaml`

**Test Specifications:**
- `test-spec-messenger-app-2026-02-04.md`

**Test Reports:**
- `integration-report-2026-02-04.md`
- `e2e-report-2026-02-04.md`
- `security-scan-report-2026-02-04.md`
- `performance-load-test-2026-02-04.md`

**Code Reviews:**
- `review-message-service-2026-02-04.md`
- `review-fix-verification-2026-02-04.md`

**Implementation Summaries:**
- `backend-impl-message-service-2026-02-04.md`
- `frontend-impl-chat-ui-2026-02-04.md`
- `devops-impl-kubernetes-deployment-2026-02-04.md`
- `database-impl-message-schema-2026-02-04.md`

**Documentation:**
- `api/message-api-reference.md`
- `architecture/adr-001-websocket-choice.md`
- `deployment/azure-deployment-guide.md`
- `guides/user-guide.md`

---

## Metadata Headers

All generated documents SHOULD include a metadata header:

```markdown
---
generated_by: <agent-name>
generation_date: YYYY-MM-DD HH:MM:SS
source_input: <path-to-input-file-or-description>
version: X.Y.Z
tech_stack: <detected-stack>
status: draft | review | approved | deprecated
---
```

**Example:**

```markdown
---
generated_by: tech-spec-architect
generation_date: 2026-02-04 14:30:00
source_input: .claude/output/briefs/validated/messenger-app-validated-brief-2026-02-04.md
version: 1.0.0
tech_stack: React 18, FastAPI 0.110, PostgreSQL 15
status: draft
---

# Backend Technical Specification
...
```

---

## Workflow Integration

### Phase 1: Validation
```
Input: Raw product brief (anywhere)
↓
product-brief-analyst
↓
Output: .claude/output/briefs/validated/<brief-name>.md
```

### Phase 2: Specification
```
Input: .claude/output/briefs/validated/<brief-name>.md
↓
tech-spec-architect
↓
Output:
- .claude/output/specs/frontend/<spec>.md
- .claude/output/specs/backend/<spec>.md
- .claude/output/specs/architecture/<spec>.md
```

### Phase 3: Planning
```
Input: .claude/output/specs/**/*.md
↓
implementation-planner (×N)
↓
Output: .claude/plans/<feature-plan>.md
```

### Phase 4: Contract Generation
```
Input: .claude/plans/*.md (contract requirements)
↓
contract-generator
↓
Output: .claude/output/contracts/<type>/<contract>.*
```

### Phase 5: Test Specification
```
Input: .claude/output/specs/**/*.md
↓
test-spec-generator
↓
Output: .claude/output/tests/specs/test-spec-<project>.md
```

### Phase 6: Implementation
```
Input: .claude/plans/*.md + .claude/output/contracts/**/*
↓
Implementation agents (senior-backend-engineer, senior-frontend-engineer, devops-engineer, database-migration-specialist)
↓
Output:
- Actual source code in project directories
- .claude/output/implementation/<type>/impl-<feature>-<date>.md (implementation summary)
```

### Phase 7: Code Review
```
Input: Source code files
↓
code-reviewer
↓
Output: .claude/output/reviews/review-<scope>-<date>.md
```

### Phase 8: Testing
```
Input: Source code + .claude/output/tests/specs/*.md
↓
Test executors (integration, e2e, security, performance, accessibility)
↓
Output: .claude/output/tests/reports/<type>/<report>.md
```

### Phase 9: Documentation
```
Input: Source code + .claude/output/specs/**/*.md
↓
documentation-generator
↓
Output: .claude/output/docs/<type>/<doc>.md
```

---

## Directory Initialization

Agents should create directories as needed using this pattern:

```python
# Python example
from pathlib import Path

output_dir = Path(".claude/output/specs/backend")
output_dir.mkdir(parents=True, exist_ok=True)
```

```typescript
// TypeScript example
import { mkdir } from 'fs/promises';

const outputDir = '.claude/output/contracts/api';
await mkdir(outputDir, { recursive: true });
```

```bash
# Bash example
mkdir -p .claude/output/tests/reports/integration
```

---

## Cleanup Policy

### Retention Rules

- **Briefs & Specs**: Keep all versions (historical record)
- **Plans**: Keep until implementation complete, then archive
- **Contracts**: Keep all (source of truth for interfaces)
- **Implementation Summaries**: Keep all (audit trail of what was implemented)
- **Test Reports**: Keep last 10 per type, archive older
- **Reviews**: Keep all (audit trail)
- **Documentation**: Keep latest + explicitly versioned

### Archive Strategy

Create `.claude/output/archive/<year>/<month>/` for old artifacts:

```
.claude/output/archive/
└── 2026/
    ├── 01/
    │   ├── test-reports/
    │   └── reviews/
    └── 02/
        └── test-reports/
```

---

## Integration with Task Orchestration

The `/task-orchestration` skill references these output locations:

1. **Reads plans from**: `.claude/plans/*.md`
2. **Reads contracts from**: `.claude/output/contracts/**/*`
3. **Reads test specs from**: `.claude/output/tests/specs/*.md`
4. **Writes open tasks to**: `.claude/tasks/<feature-name>-<timestamp>.md`

### Task File Format

Task files follow this naming convention:
- **Pattern**: `<feature-name>-<timestamp>.md`
- **Example**: `workspace-sync-2026-02-09-14-30.md`
- **Location**: `.claude/tasks/`

Each task file contains:
- Feature/project name and description
- Wave-based work units with dependencies
- Current status (pending, in_progress, completed)
- Agent assignments and dispatch history
- Progress tracking and completion metrics

---

## Version Control Considerations

### .gitignore Recommendations

```gitignore
# Keep structure and documentation
!.claude/output/README.md
!.claude/OUTPUT_STRUCTURE.md

# Archive old test reports
.claude/output/tests/reports/**/202[0-4]-*
.claude/output/archive/

# Keep recent outputs
!.claude/output/briefs/validated/*.md
!.claude/output/specs/**/*.md
!.claude/output/plans/*.md
!.claude/output/contracts/**/*
!.claude/output/implementation/**/*.md
!.claude/output/tests/specs/*.md
!.claude/output/docs/**/*.md

# Keep last 5 test reports
.claude/output/tests/reports/**/*
!.claude/output/tests/reports/**/$(ls -t | head -5)
```

---

## Migration from Current State

If agents currently write to different locations:

1. **Create new structure**: `mkdir -p .claude/output/{briefs,specs,contracts,tests,reviews,implementation,docs}`
2. **Update agent prompts**: Modify agents to use new paths
3. **Move existing files**: Migrate current outputs to new locations
4. **Update references**: Search for hardcoded paths and replace

---

## Future Enhancements

1. **Metadata index**: Generate `.claude/output/INDEX.md` listing all outputs
2. **Dependency graph**: Track which outputs depend on which inputs
3. **Auto-cleanup**: Script to archive old test reports
4. **Search tool**: Helper to find outputs by agent/date/type
5. **Diff viewer**: Compare versions of specs/plans

---

## Summary

**Key Principle**: All agent-generated artifacts go under `.claude/output/` organized by type and phase, with consistent naming and metadata. This enables:

- Easy discovery of agent outputs
- Clear separation from source code
- Traceable lineage of generated artifacts
- Simplified orchestration and dependency tracking
- Better version control and cleanup policies

**For Agents**: When writing output files, always use the paths defined in this document and include the metadata header.

**For Orchestrators**: Reference these standard paths when coordinating multi-agent workflows.
