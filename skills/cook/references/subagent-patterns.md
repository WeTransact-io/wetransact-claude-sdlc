# Subagent Patterns

Standard patterns for spawning and using subagents in cook workflows.

## Task Tool Pattern
```
Task(subagent_type="[type]", prompt="[task description]", description="[brief]")
```

## Research Phase
Use WebSearch/WebFetch directly for research (max 5 searches per topic).
- Keep research notes ≤150 lines with citations

## Codebase Search Phase
```
Task(subagent_type="Explore", prompt="Search [directories] for files related to [feature]. Use Glob/Grep/Read.", description="Search [feature]")
```
- Use Explore subagents with Glob/Grep for codebase search

## Planning Phase
```
Task(subagent_type="implementation-planner", prompt="Create implementation plan based on reports: [reports]. Save to [path]", description="Plan [feature]")
```
- Input: research findings and codebase search results
- Output: `plan.md` + `phase-XX-*.md` files

## UI Implementation
```
Task(subagent_type="senior-frontend-engineer", prompt="Implement [feature] UI per ./docs/design-guidelines.md", description="UI [feature]")
```
- For frontend work (handles UI design and implementation)
- Follow design guidelines

## Testing
```
Task(subagent_type="integration-test-executor", prompt="Run test suite for plan phase [phase-name]", description="Test [phase]")
```
- Must achieve 100% pass rate
- Use `e2e-test-executor` instead if the context is about UI/browser testing

## Debugging
```
Task(subagent_type="debugger", prompt="Analyze failures: [details]", description="Debug [issue]")
```
- Use when tests fail
- Provides root cause analysis

## Code Review
```
Task(subagent_type="code-reviewer", prompt="Review changes for [phase]. Check security, performance, YAGNI/KISS/DRY. Return score (X/10), critical, warnings, suggestions.", description="Review [phase]")
```

## Documentation
```
Task(subagent_type="documentation-generator", prompt="Update docs for [phase]. Changed files: [list]", description="Update docs")
```

## Git Operations
```
Task(subagent_type="git-manager", prompt="Stage and commit changes with conventional commit message", description="Commit changes")
```

## Parallel Execution
```
Task(subagent_type="senior-backend-engineer", prompt="Implement backend for [phase-file] with file ownership: [files]", description="Implement backend phase [N]")
Task(subagent_type="senior-frontend-engineer", prompt="Implement frontend for [phase-file] with file ownership: [files]", description="Implement frontend phase [N]")
```
- Spawn both `senior-backend-engineer` and `senior-frontend-engineer` in parallel
- Launch multiple for parallel phases
- Include file ownership boundaries
