---
description: No research. Only analyze, plan & implement
argument-hint: [tasks-or-prompt]
---

Think harder to plan & start working on these tasks follow the Orchestration Protocol, Core Responsibilities, Subagents Team and Development Rules:
<tasks>$ARGUMENTS</tasks>

**IMPORTANT:** Analyze the skills catalog and activate the skills that are needed for the task during the process.
**Ensure token efficiency while maintaining high quality.**

## Workflow:

- **Analyze**: Use Explore subagents with Glob/Grep to find related resources, documents, and code snippets in the current codebase.
- **Plan**: Trigger `/plan:fast <detailed-instruction-prompt>` to create an implementation plan based on the codebase analysis.
- **Implementation**: Implement the plan step by step using `senior-backend-engineer` and `senior-frontend-engineer` subagents as needed. Skip code review step.
- **Commit**: Use `AskUserQuestion` to ask user if they want to commit, if yes trigger `/git:cm`.
