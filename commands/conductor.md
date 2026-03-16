---
description: Create a comprehensive, interconnected scaffolded documentation system
allowed-tools: ["Glob", "Read", "Edit", "AskUserQuestion", "Skill", "Grep", "Write", "WebFetch", "WebSearch"]
---

Create a comprehensive, interconnected scaffolded documentation system that helps Claude Code understand and navigate your codebase more effectively, and retain better context.

## Table of Contents

- [What To Do](#what-to-do)
- [Documentation Templates](#documentation-templates)
  - [Core Templates](#core-templates-default)
  - [Full Template Set](#full-template-set)
- [Quick Start](#quick-start)
- [Features](#features)
  - [Intelligent Codebase Analysis](#intelligent-codebase-analysis)
  - [Modular Documentation](#-modular-documentation)
  - [Development Journal](#-development-journal)
  - [Error Tracking](#error-tracking)
  - [Security Checkup](#security-checkup)
- [Example Output](#example-output)
- [Best Practices](#best-practices)
- [Framework Philosophy](#framework-philosophy)

### External Resources

- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices.md) — How to configure an effective environment 
- [Software Development Lifecycle](../.claude/SOFTWARE_DEVELOPMENT_LIFECYCLE.md)
- [Output Structure](../.claude/OUTPUT_STRUCTURE.md)
- [Index](../.claude/INDEX.md)
- [Output Files](../.claude/output/)

## What To Do

**CRITICAL: Follow these steps in order:**

### Step 1: Initialize Templates (ALWAYS DO THIS FIRST)
```bash
# Run this command via Bash tool to create all template files
npx claude-conductor
```

This creates the full template set with placeholders. **You MUST run this command first**, even if some files already exist. The command is idempotent and won't overwrite existing files.

### Step 2: Analyze Codebase & Populate Templates

After templates are created, populate ALL template files with project-specific details:

- **Organizes** project documentation into focused, interconnected modules
- **Optimizes** for AI navigation with line numbers, anchors, and keywords
- **Tracks** development history with an auto-archiving journal system
- **Monitors** critical errors with a dedicated error ledger
- **Analyzes** the codebase to pre-populate documentation
- **Manages** active tasks with phase tracking and context preservation (TASKS.md)
- **Performs** comprehensive security health check (SECURITY.md)

## Documentation Templates

### Core Templates (Default)
- **CONDUCTOR.md** - Master navigation hub and framework reference
- **CLAUDE.md** - AI assistant guidance tailored to the project
- **ARCHITECTURE.md** - System design and tech stack
- **BUILD.md** - Build, test, and deployment commands
- **JOURNAL.md** - Development changelog (auto-created)

### Full Template Set
All core templates plus:
- **API.md** - API endpoints and contracts
- **CONFIG.md** - Configuration and environment variables
- **DATA_MODEL.md** - Database schema and models
- **DESIGN.md** - Visual design system
- **UIUX.md** - User interface patterns
- **TEST.md** - Testing strategies and examples
- **CONTRIBUTING.md** - Contribution guidelines
- **ERRORS.md** - Critical error tracking
- **PLAYBOOKS/DEPLOY.md** - Deployment procedures
- **TASKS.md** - Active task management and phase tracking
- **SECURITY.md** - Security findings logs

## Quick Start

**MANDATORY EXECUTION ORDER:**

### Step 1: Always Initialize Templates First

**You MUST execute this command via Bash tool:**

```bash
npx claude-conductor
```

This creates the complete template set (15 files) with structured placeholders. The command is **idempotent** - it won't overwrite existing files but will create any missing ones.

**Expected Output:**
- CONDUCTOR.md
- CLAUDE.md
- ARCHITECTURE.md
- BUILD.md
- API.md
- CONFIG.md
- DATA_MODEL.md
- DESIGN.md
- UIUX.md
- TEST.md
- CONTRIBUTING.md
- ERRORS.md
- PLAYBOOKS/DEPLOY.md
- TASKS.md
- SECURITY.md
- JOURNAL.md (auto-created)

### Step 2: Perform Deep Codebase Analysis

After templates are created, run a comprehensive analysis to populate ALL template files with project-specific details:

**Analysis Request:**
```
"Please thoroughly review this codebase, update CLAUDE.md with project context, and use CONDUCTOR.md as a guide to fill out all the documentation files. Also check for any syntax errors, bugs, or suggestions for improvement. Additionally, perform a comprehensive security health check and list any potential vulnerabilities or concerns (like exposed .env files, API keys in code, missing .gitignore entries, outdated dependencies with known vulnerabilities, insecure configurations, or other security best practice violations) - just list them as warnings, don't fix anything."
```

### Step 3: Complete All Template Files

**You MUST populate every template file with project-specific content:**

1. ✅ **Analyze** the codebase structure and dependencies
2. ✅ **Fill** CLAUDE.md Critical Context with actual project details
3. ✅ **Update** all file references with real line numbers
4. ✅ **Populate** ARCHITECTURE.md with system design and ADRs
5. ✅ **Document** BUILD.md with build, test, and deployment procedures
6. ✅ **Map** API.md with all REST/GraphQL endpoints
7. ✅ **List** CONFIG.md with all environment variables
8. ✅ **Define** DATA_MODEL.md with database schema
9. ✅ **Describe** DESIGN.md with visual design tokens
10. ✅ **Explain** UIUX.md with component hierarchy
11. ✅ **Outline** TEST.md with testing strategies
12. ✅ **Write** CONTRIBUTING.md with development guidelines
13. ✅ **Create** PLAYBOOKS/DEPLOY.md with deployment procedures
14. ✅ **Initialize** TASKS.md with current phase tracking
15. ✅ **Setup** ERRORS.md error ledger structure
16. ✅ **Fill** CONDUCTOR.md with actual Quick Reference tables
17. ✅ **Create** meaningful task templates based on Software Development Lifecycle specifications
18. ✅ **Setup** proper cross-linking between all documents
19. ✅ **Perform** comprehensive security health check → populate SECURITY.md
20. ⚠️ **Flag** security issues as warnings (don't fix, just document)

## Features

### Intelligent Codebase Analysis

#### Default Analysis
- Detects tech stack automatically
- Identifies main files and entry points
- Maps directory structure

#### Deep Scan Analysis 
All default features plus:
- **Framework Detection**: React, Vue, Angular, Express, Next.js versions
- **Dependency Analysis**: Lists all dependencies with versions
- **API Mapping**: Finds and documents API endpoints
- **Component Discovery**: Maps React/Vue components
- **Build Scripts**: Extracts all build scripts
- **Database Schema**: Detects Prisma schemas, SQL files, models
- **Updates Multiple Files**: ARCHITECTURE.md and BUILD.md get detailed updates

### 📋 Modular Documentation
- Each aspect gets its own focused file
- Cross-linked for easy navigation
- Optimized for AI comprehension
- Keyword sections for searchability

### 📖 Development Journal
- Continuous changelog in JOURNAL.md
- Auto-archives when exceeding 500 lines
- Tracks major changes, bug fixes, and decisions
- Links to error tracking system

### Error Tracking
- P0/P1 critical error ledger
- Systematic error ID format
- Links between errors and fixes
- Resolution tracking

### Security Checkup
Checks for:
- Exposed .env files or API keys in code
- Unsafe innerHTML usage that could lead to XSS
- Missing .gitignore entries for sensitive files
- Hardcoded credentials or secrets
- Common security anti-patterns
- Update SECURITY.md with logs

**Note**: This checkup is informational only and will never modify the code.

## Example Output

After running `conductor`, you'll have:

```
project/
├── CONDUCTOR.md
├── CLAUDE.md
├── ARCHITECTURE.md
├── BUILD.md
├── API.md
├── CONFIG.md
├── DATA_MODEL.md
├── DESIGN.md
├── UIUX.md
├── TEST.md
├── CONTRIBUTING.md
├── ERRORS.md
├── JOURNAL.md
├── SECURITY.md
└── PLAYBOOKS/
    └── DEPLOY.md
```

## Best Practices

### Start Lean
Begin with core templates and let the documentation grow organically

### Use Deep Scans for Existing Projects
For mature codebases, use deep scans to capture comprehensive details

### Maintain the Journal
The JOURNAL.md file is the development history:
- Add entries for significant changes
- Document debugging sessions
- Track architectural decisions
- Link to error resolutions

### Use with Claude Code
When working with Claude Code:
1. Claude will reference the documentation automatically
2. Updates happen organically during development
3. Cross-links help Claude navigate efficiently

### What Claude Will Do When You Run /conductor:

**Phase 1: Initialize Templates (MANDATORY)**
- 🔧 Execute `npx claude-conductor` via Bash tool
- 📄 Create all 15+ template files with structured placeholders

**Phase 2: Populate All Templates**
- ✅ Analyze your codebase structure and dependencies
- ✅ Fill in the Critical Context section with actual project details
- ✅ Update file references with real line numbers
- ✅ Populate ARCHITECTURE.md, BUILD.md, and API.md with comprehensive documentation
- ✅ Complete CONFIG.md, DATA_MODEL.md, DESIGN.md, UIUX.md, TEST.md
- ✅ Fill CONTRIBUTING.md, PLAYBOOKS/DEPLOY.md, ERRORS.md, TASKS.md
- ✅ Create meaningful task templates based on your workflow
- ✅ Set up proper cross-linking between all documents
- 🔒 **Security Health Check**: Scan for common vulnerabilities and security concerns
- ⚠️ **Warning List**: Flag any security issues found (without making changes)

**Note**: This is a comprehensive one-time setup. Claude will ALWAYS:
1. First run `npx claude-conductor` to create templates
2. Then populate every template file with project-specific content

### If You Already Have a CLAUDE.md File

If Claude Conductor detects an existing CLAUDE.md file, it will preserve it and skip creating a new one. To ensure optimal integration with the Conductor framework, please manually add this section to your existing CLAUDE.md:

```markdown
## Journal Update Requirements
**IMPORTANT**: Update JOURNAL.md regularly throughout our work sessions:
- After completing any significant feature or fix
- When encountering and resolving errors
- At the end of each work session
- When making architectural decisions
- Format: What/Why/How/Issues/Result structure
```

This ensures Claude maintains a detailed development history in JOURNAL.md, which is a core feature of the Conductor framework.

**For Security Checkups**: Use the `npx claude-conduct checkup` command whenever you want to check for vulnerabilities.

## Framework Philosophy

1. **Modular > Monolithic** - Separate concerns into focused files
2. **Practical > Theoretical** - Include real examples and patterns
3. **Maintained > Stale** - Regular updates through development
4. **Navigable > Comprehensive** - Easy to find what you need

## Keywords

claude, claude code, documentation, ai development, conductor, framework, claude conductor, vibe coding, super basic studio