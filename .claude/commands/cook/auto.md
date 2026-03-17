---
description: Implement a feature automatically
argument-hint: [tasks]
---

Think harder to plan & start working on these tasks follow the Orchestration Protocol, Core Responsibilities, Subagents Team and Development Rules:
<tasks>$ARGUMENTS</tasks>

**IMPORTANT:** Analyze the skills catalog and activate the skills that are needed for the task during the process.
**Ensure token efficiency while maintaining high quality.**

## Workflow:
1. Trigger `/plan:fast <detailed-instruction-prompt>` to create an implementation plan based on the given tasks.
2. Spawn appropriate engineer agents (`senior-backend-engineer`, `senior-frontend-engineer`) for implementation of the plan.
3. Use `integration-test-executor` subagent to run tests and verify the implementation.
4. Use `code-reviewer` subagent to review the code changes.
5. Use `AskUserQuestion` tool to ask user if they want to commit, if yes trigger `/git:cm` to create a commit.
