# Log & CI/CD Analysis

## GitHub Actions Commands

```bash
gh run list --limit 10                    # Recent runs
gh run list --workflow=ci.yml --limit 5   # Specific workflow
gh run view <run-id>                      # Run details
gh run view <run-id> --log-failed         # Failed job logs only
gh run view <run-id> --log > /tmp/ci.txt  # Download full logs
gh run rerun <run-id> --failed            # Re-run failed jobs
```

## Common CI/CD Failure Patterns

| Pattern | Likely Cause |
|---------|-------------|
| Passes locally, fails CI | Env diff — check Node/Python version, OS, env vars |
| Intermittent failures | Race conditions, flaky tests, shared state |
| Timeout failures | Resource limits, infinite loops |
| Permission errors | Token/secret misconfiguration |
| Dependency install fails | Registry issues, lockfile conflicts |
| Build OK, tests fail | Test env setup, database, fixtures |

## Log Analysis Strategy

1. **Filter by timeframe** — Narrow to incident window
2. **Correlate request IDs** — Trace single request across services
3. **Build timeline** — First error → propagation → user impact
4. **Identify trigger** — What changed immediately before first error?

## Error Pattern Recognition

- **Sudden spike** → Deployment, config change, external dependency
- **Gradual increase** → Resource leak, data growth
- **Periodic failures** → Cron jobs, resource contention
- **Single endpoint** → Code bug, data issue
- **All endpoints** → Infrastructure, database, network
