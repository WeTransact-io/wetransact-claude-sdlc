---
description: Validate an implementation plan by asking focused stakeholder questions
allowed-tools: ["Read", "Glob", "Grep", "AskUserQuestion"]
---

# Plan Validation

Validate the active implementation plan by asking the user focused questions about assumptions, risks, tradeoffs, and architecture.

## Process

1. **Read the active plan** — Check `$CK_ACTIVE_PLAN` or `$CK_SUGGESTED_PLAN` environment variables, or ask the user which plan to validate
2. **Analyze the plan** — Identify assumptions, risks, tradeoffs, and architectural decisions
3. **Ask focused questions** — Use AskUserQuestion to validate key decisions with the user
   - Minimum questions: 3
   - Maximum questions: 8
   - Focus areas: assumptions, risks, tradeoffs, architecture
4. **Document answers** — Update the plan with validated decisions and rationale
5. **Mark plan as validated** — Add `status: validated` to plan metadata

## Question Templates

- "The plan assumes X. Is this correct, or should we consider Y?"
- "This approach trades off A for B. Is that acceptable for your use case?"
- "The architecture uses pattern X. Have you considered alternative Z?"
- "Risk identified: X could cause Y. What is your mitigation preference?"

## Output

Update the plan file with a `## Validation` section documenting each question, answer, and any plan adjustments made.
