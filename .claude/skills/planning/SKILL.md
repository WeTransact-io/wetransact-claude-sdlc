---
name: planning
description: Plan implementations, design architectures, create technical roadmaps with detailed phases. Use for feature planning, system design, solution architecture, implementation strategy, phase documentation.
---

# Planning

Create detailed technical implementation plans through research, codebase analysis, solution design, and comprehensive documentation.

## When to Use

Use this skill when:
- Planning new feature implementations
- Architecting system designs
- Evaluating technical approaches
- Creating implementation roadmaps
- Breaking down complex requirements
- Assessing technical trade-offs

## Smart Routing

Analyze task complexity and route to the appropriate planning variant:
- Simple task, no research needed → `/plan:fast <enhanced-prompt>`
- Complex task, needs research → `/plan:hard <enhanced-prompt>`
- Multiple independent features needing parallel execution → `/plan:parallel <enhanced-prompt>`

Use `AskUserQuestion` to clarify task details if needed before routing. Enhance the user's prompt with additional detail before passing to the sub-command.

## Core Responsibilities & Rules

Always honoring **YAGNI**, **KISS**, and **DRY** principles.
**Be honest, be brutal, straight to the point, and be concise.**

### 1. Research & Analysis
Use WebSearch/WebFetch to investigate approaches and find docs. Use `gh` for GitHub analysis. Skip if provided with research reports.

### 2. Codebase Understanding
Use Explore subagents with Glob/Grep for file discovery. Read `./docs/` documentation first. Study existing patterns. Skip if provided with codebase analysis.

### 3. Plan Creation & Organization
Load: `references/plan-organization.md`

## Workflow Process

1. **Initial Analysis** → Read codebase docs, understand context
2. **Research Phase** → WebSearch/WebFetch, investigate approaches
3. **Synthesis** → Analyze reports, identify optimal solution
4. **Design Phase** → Create architecture, implementation design
5. **Plan Documentation** → Write comprehensive plan
6. **Review & Refine** → Ensure completeness, clarity, actionability

## Output Requirements

- DO NOT implement code - only create plans
- Respond with plan file path and summary
- Ensure self-contained plans with necessary context
- Include code snippets/pseudocode when clarifying
- Provide multiple options with trade-offs when appropriate
- Fully respect the `./docs/development-rules.md` file.

## Task Integration (Optional)

When session has `CLAUDE_CODE_TASK_LIST_ID` set (active plan):
- Use TaskCreate to create tasks for each phase with clear subjects
- Set dependencies: Phase N+1 `blockedBy` Phase N
- Subagents coordinate via shared task list automatically
- Use TaskUpdate to mark progress (in_progress → completed)

### Important
DO NOT create plans or reports in USER directory.
ALWAYS create plans or reports in CURRENT WORKING PROJECT DIRECTORY.

**Plan Directory Structure**
IN CURRENT WORKING PROJECT DIRECTORY:
```
plans/
└── {date}-plan-name/
    ├── research/
    │   ├── research-XX-report.md
    │   └── ...
    ├── reports/
    │   ├── XX-report.md
    │   └── ...
    ├── plan.md
    ├── phase-XX-phase-name-here.md
    └── ...
```

## Active Plan State

Prevents version proliferation by tracking current working plan via session state.

### Active vs Suggested Plans

Check the `## Plan Context` section injected by hooks:
- **"Plan: {path}"** = Active plan, explicitly set via `set-active-plan.cjs` - use for reports
- **"Suggested: {path}"** = Branch-matched, hint only - do NOT auto-use
- **"Plan: none"** = No active plan

### Rules

1. **If "Plan:" shows a path**: Ask "Continue with existing plan? [Y/n]"
2. **If "Suggested:" shows a path**: Inform user, ask if they want to activate or create new
3. **If "Plan: none"**: Create new plan using naming from `## Naming` section
4. **After creating plan**: The session-init hook auto-resolves plans on next session start

### Report Output Location

All agents writing reports MUST:
1. Check `## Naming` section injected by hooks for the computed naming pattern
2. Active plans use plan-specific reports path
3. Suggested plans use default reports path (not plan folder)

### Important
DO NOT create plans or reports in USER directory.
ALWAYS create plans or reports in CURRENT WORKING PROJECT DIRECTORY.

**Important:** Suggested plans do NOT get plan-specific reports - this prevents pollution of old plan folders.

## Quality Standards

- Be thorough and specific
- Consider long-term maintainability
- Research thoroughly when uncertain
- Address security and performance concerns
- Make plans detailed enough for junior developers
- Validate against existing codebase patterns

**Remember:** Plan quality determines implementation success. Be comprehensive and consider all solution aspects.
