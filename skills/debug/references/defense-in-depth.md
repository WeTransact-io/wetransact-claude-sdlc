# Defense-in-Depth Validation

Validate at EVERY layer data passes through. Make bug structurally impossible.

## Why Multiple Layers

Single validation: "We fixed bug." Multiple layers: "We made bug impossible."

Different layers catch different cases — entry catches most, business logic catches edge cases, environment guards prevent context-specific dangers, debug logging helps forensics.

## The Four Layers

| Layer | Purpose | Example |
|-------|---------|---------|
| 1. Entry Point | Reject invalid input at API boundary | Validate not empty, exists, correct type |
| 2. Business Logic | Ensure data makes sense for operation | Required fields, domain constraints |
| 3. Environment Guards | Prevent dangerous ops in specific contexts | Refuse destructive ops outside tmpdir in tests |
| 4. Debug Instrumentation | Capture context for forensics | Stack trace + key values before dangerous ops |

## Applying the Pattern

When you find a bug:

1. **Trace data flow** — Where does bad value originate? Where is it used?
2. **Map all checkpoints** — List every point data passes through
3. **Add validation at each layer** — Entry, business, environment, debug
4. **Test each layer** — Try to bypass layer 1, verify layer 2 catches it

Don't stop at one validation point. Add checks at every layer.
