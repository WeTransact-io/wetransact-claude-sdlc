---
name: edge-case-scouting
description: Use after implementation, before code review to proactively find edge cases, side effects, and potential issues - catches problems code-reviewer might miss
---

# Edge Case Scouting

Proactive detection of edge cases, side effects, and potential issues before code review.

## Purpose

Code reviews catch obvious issues but miss subtle side effects. Edge case analysis detects:
- Files affected by changes reviewer might not check
- Data flow paths that could break
- Boundary conditions and error paths
- Integration issues across modules

## When to Use

**Mandatory:** Multi-file features, shared utility refactors, complex bug fixes
**Optional:** Single-file changes, docs, config

## Process

### 1. Identify Changed Files
```bash
git diff --name-only HEAD~1
```

### 2. Search for Edge Cases

Use Explore subagents or Glob/Grep to find:
1. Files importing/depending on changed modules
2. Data flow paths through modified functions
3. Error handling paths not tested
4. Boundary conditions (null, empty, max)
5. Race conditions in async code
6. State management side effects

### 3. Analyze & Act

| Finding | Action |
|---------|--------|
| Affected file not in scope | Add to review |
| Data flow risk | Verify or add test |
| Edge case | Add test or verify |
| Missing test | Add before review |

### 4. Document for Review
```
Scout findings:
- {issues found}
- Verified: {what checked}
- Addressed: {what fixed}
- Needs review: {remaining}
```

## Search Prompts

**Feature:** "Find consumers, error states, untested inputs for {files}"
**Bug fix:** "Find other paths using same logic, dependent features, similar bugs in {file}"
**Refactor:** "Find importers, behavior diffs, removed functionality for {module}"

## What Edge Case Analysis Catches

| Issue | Why Missed | Detection Method |
|-------|------------|-----------------|
| Indirect deps | Not in diff | Grep for imports |
| Race conditions | Hard static review | Analyze async flow |
| State mutations | Hidden side effects | Track data paths |
| Missing null checks | Assumed safe | Boundary analysis |
| Integration breaks | Out of scope | Cross-module Grep |

## Red Flags

- Shared utility changed but only one caller tested
- Error path leads to unhandled rejection
- State modified in place without notification
- Breaking change without migration

## Example

```
1. Done: Add cache to UserService.getUser()
2. Diff: src/services/user-service.ts
3. Scout: "edge cases for caching in getUser()"
4. Report:
   - ProfileComponent expects fresh data on edit
   - AdminPanel loops getUser() (memory risk)
   - No cache clear on updateUser()
5. Fix: Add invalidation, maxSize
6. Document for code-reviewer
```

## Bottom Line

Analyze edge cases before review. Don't trust "simple changes" - check them anyway.
