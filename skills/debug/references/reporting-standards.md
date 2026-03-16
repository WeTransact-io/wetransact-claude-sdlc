# Reporting Standards

Structured format for diagnostic reports. Sacrifice grammar for concision.

## Template

```markdown
# [Issue Title] - Investigation Report

## Executive Summary
- **Issue:** One-line description
- **Impact:** Users/systems affected, severity
- **Root cause:** One-line explanation
- **Status:** Resolved / Mitigated / Under investigation
- **Fix:** What was done or recommended

## Timeline
- HH:MM - Event description

## Technical Analysis
### Findings
1. Finding with supporting evidence (distinguish facts from hypotheses)

### Evidence
[Relevant log excerpts, query results, stack traces, before/after comparisons]

## Recommendations
### Immediate (P0)
- [ ] Critical fix — what, why, expected impact

### Short-term (P1)
- [ ] Follow-up improvements

### Long-term (P2)
- [ ] Monitoring/architecture improvements

## Unresolved Questions
- Items needing further investigation
```

## Writing Guidelines

- Every claim backed by evidence (logs, metrics, repro steps)
- Recommendations specific with clear next steps
- State unknowns explicitly: "likely cause" vs "confirmed cause"
- Use naming pattern from `## Naming` section injected by hooks
