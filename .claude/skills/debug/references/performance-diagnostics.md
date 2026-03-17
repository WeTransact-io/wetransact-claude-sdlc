# Performance Diagnostics

## Diagnostic Process

1. **Quantify** — Measure baseline vs current. When did it start? Which endpoints?
2. **Locate bottleneck layer** — Eliminate layer by layer:

| Layer | Check with |
|-------|-----------|
| Network | `curl -w` timing |
| Application | Profiler, `process.memoryUsage()` |
| Database | `EXPLAIN ANALYZE`, `pg_stat_statements` |
| Filesystem | `iostat`, `df -h` |
| External APIs | Request logging with durations |

3. **Fix in priority order** — Quick wins → Config tuning → Code changes → Architecture

## Key PostgreSQL Queries

```sql
-- Slow queries
SELECT query, calls, mean_exec_time FROM pg_stat_statements ORDER BY mean_exec_time DESC LIMIT 20;

-- Active queries
SELECT pid, now() - query_start AS duration, query, state FROM pg_stat_activity WHERE state != 'idle' ORDER BY duration DESC;

-- Missing indexes (sequential scans on large tables)
SELECT relname, seq_scan, seq_tup_read, idx_scan FROM pg_stat_user_tables WHERE seq_scan > 100 AND seq_tup_read > 10000 ORDER BY seq_tup_read DESC;

-- Connection pool status
SELECT count(*), state FROM pg_stat_activity GROUP BY state;
```

## Common Bottlenecks

| Issue | Symptom | Fix |
|-------|---------|-----|
| N+1 queries | Many small DB calls/request | Eager loading, batch queries |
| Memory leaks | Growing memory over time | Profile heap, check event listeners |
| Blocking I/O | High response time, low CPU | Async operations, connection pooling |
| Connection exhaustion | Intermittent timeouts | Pool sizing, connection reuse |

Always measure after each change. One change at a time.
