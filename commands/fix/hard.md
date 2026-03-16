---
description: Use subagents to plan and fix hard issues
argument-hint: [issues]
---

**Ultrathink** to plan & start fixing these issues follow the Orchestration Protocol, Core Responsibilities, Subagents Team and Development Rules:
<issues>$ARGUMENTS</issues>

## Workflow:

If the user provides screenshots or videos, describe as detailed as possible the issue, make sure developers can predict the root causes easily based on the description.

### Fullfill the request
**Question Everything**: Use `AskUserQuestion` tool to ask probing questions to fully understand the user's request, constraints, and true objectives. Don't assume - clarify until you're 100% certain.

* If you have any questions, use `AskUserQuestion` tool to ask the user to clarify them.
* Ask 1 question at a time, wait for the user to answer before moving to the next question.
* If you don't have any questions, start the next step.

### Fix the issue

Use `debug` skill to break complex problems into sequential thought steps and tackle the issues.
Analyze the skills catalog and activate other skills that are needed for the task during the process.

1. Use `debugger` subagent to find the root cause of the issues and report back to main agent.
2. Use WebSearch/WebFetch to research the root causes on the internet (if needed).
3. Use `implementation-planner` subagent to create an implementation plan based on the reports, then use `AskUserQuestion` to validate the investigation plan with the user before proceeding.
4. Then use `/cook` SlashCommand to implement the plan step by step.
5. Final Report:
  * Report back to user with a summary of the changes and explain everything briefly, guide user to get started and suggest the next steps.
  * Ask the user if they want to commit and push to git repository, if yes, use `git-manager` subagent to commit and push to git repository.
  - **IMPORTANT:** Sacrifice grammar for the sake of concision when writing reports.
  - **IMPORTANT:** In reports, list any unresolved questions at the end, if any.

**REMEMBER**:
- For image editing (removing background, adjusting, cropping), use ImageMagick or similar tools as needed.
