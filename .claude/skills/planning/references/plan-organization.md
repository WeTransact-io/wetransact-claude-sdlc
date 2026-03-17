# Plan Creation & Organization

## Directory Structure

### Plan Location

**Important:**
- DO NOT create plans or reports in USER directory.
- ALWAYS create plans or reports in CURRENT WORKING PROJECT DIRECTORY.

Use `Plan dir:` from `## Naming` section injected by hooks. This is the full computed path.

**Example:** `plans/251101-1505-authentication/` or `ai_docs/feature/MRR-1453/`

### File Organization

IN CURRENT WORKING PROJECT DIRECTORY:
```
{plan-dir}/                                    # From `Plan dir:` in ## Naming
├── research/
│   ├── research-XX-report.md
│   └── ...
├── reports/
│   ├── research-report.md
│   └── ...
├── plan.md                                    # Overview access point
├── phase-01-setup-environment.md              # Setup environment
├── phase-02-implement-database.md             # Database models
├── phase-03-implement-api-endpoints.md        # API endpoints
├── phase-04-implement-ui-components.md        # UI components
├── phase-05-implement-authentication.md       # Auth & authorization
├── phase-06-implement-profile.md              # Profile page
└── phase-07-write-tests.md                    # Tests
```

### Active Plan State Tracking

Check the `## Plan Context` section injected by hooks:
- **"Plan: {path}"** = Active plan - use for reports
- **"Suggested: {path}"** = Branch-matched, hint only - do NOT auto-use
- **"Plan: none"** = No active plan

**Pre-Creation Check:**
1. If "Plan:" shows a path → ask "Continue with existing plan? [Y/n]"
2. If "Suggested:" shows a path → inform user (hint only, do NOT auto-use)
3. If "Plan: none" → create new plan using naming from `## Naming` section

**After Creating Plan:**
The session-init hook auto-resolves plans on next session start. No manual activation needed.

**Report Output Rules:**
1. Use `Report:` and `Plan dir:` from `## Naming` section
2. Active plans use plan-specific reports path
3. Suggested plans use default reports path to prevent old plan pollution

## File Structure

**Important:**
- DO NOT create plans or reports in USER directory.
- ALWAYS create plans or reports in CURRENT WORKING PROJECT DIRECTORY.

### YAML Frontmatter (Required for plan.md)

```yaml
---
title: "{Brief plan title}"
description: "{One-sentence summary for card preview}"
status: pending  # pending | in-progress | completed | cancelled
priority: P2     # P1 (High) | P2 (Medium) | P3 (Low)
effort: 4h       # Estimated total effort
issue: 74        # GitHub issue number (if applicable)
branch: kai/feat/feature-name
tags: [frontend, api]  # Category tags
created: 2025-12-16
---
```

**Auto-populate:** title from task, description from overview, status=pending, priority from user or P2, effort from phase sum, issue from branch/context, branch from git, tags inferred from keywords, created=today.

**Tag vocabulary:** Type: `feature`, `bugfix`, `refactor`, `docs`, `infra` | Domain: `frontend`, `backend`, `database`, `api`, `auth` | Scope: `critical`, `tech-debt`, `experimental`

### Overview Plan (plan.md)

**Example plan.md structure:**
```markdown
---
title: "Feature Implementation Plan"
description: "Add user authentication with OAuth2 support"
status: pending
priority: P1
effort: 8h
issue: 123
branch: kai/feat/oauth-auth
tags: [auth, backend, security]
created: 2025-12-16
---

# Feature Implementation Plan

## Overview

Brief description of what this plan accomplishes.

## Phases

| # | Phase | Status | Effort | Link |
|---|-------|--------|--------|------|
| 1 | Setup | Pending | 2h | [phase-01](./phase-01-setup.md) |
| 2 | Implementation | Pending | 4h | [phase-02](./phase-02-impl.md) |
| 3 | Testing | Pending | 2h | [phase-03](./phase-03-test.md) |

## Dependencies

- List key dependencies here
```

**Guidelines:**
- Keep generic and under 80 lines
- List each phase with status/progress
- Link to detailed phase files
- Key dependencies

### Phase Files (phase-XX-name.md)
Fully respect the `./docs/development-rules.md` file.
Each phase file should contain:

**Context Links**
- Links to related reports, files, documentation

**Overview**
- Priority
- Current status
- Brief description

**Key Insights**
- Important findings from research
- Critical considerations

**Requirements**
- Functional requirements
- Non-functional requirements

**Architecture**
- System design
- Component interactions
- Data flow

**Related Code Files**
- List of files to modify
- List of files to create
- List of files to delete

**Implementation Steps**
- Detailed, numbered steps
- Specific instructions

**Todo List**
- Checkbox list for tracking

**Success Criteria**
- Definition of done
- Validation methods

**Risk Assessment**
- Potential issues
- Mitigation strategies

**Security Considerations**
- Auth/authorization
- Data protection

**Next Steps**
- Dependencies
- Follow-up tasks

## Task Breakdown

- Transform complex requirements into manageable, actionable tasks
- Each task independently executable with clear dependencies
- Include specific file paths for all modifications
- Provide clear acceptance criteria per task
- List affected files with: full paths, action type (modify/create/delete), brief change description

## Writing Style

- Sacrifice grammar for concision
- Use bullets and lists, short sentences
- Remove unnecessary words
- Prioritize actionable info
- Use `AskUserQuestion` for unresolved questions at the end
