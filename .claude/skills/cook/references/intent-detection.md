# Intent Detection Logic

Detect user intent from natural language and route to appropriate workflow or sub-command.

## Detection Algorithm

```
FUNCTION detectMode(input):
  # Priority 1: Plan path detection
  IF input matches path pattern (./plans/*, plan.md, phase-*.md):
    RETURN "code"  # Execute existing plan (handled by cook skill)

  # Priority 2: Keyword detection (case-insensitive)
  keywords = lowercase(input)

  IF keywords contains ["auto", "trust me", "yolo", "just do it"]:
    # Check for auto sub-variants
    IF keywords contains ["fast", "quick", "rapidly", "asap"]:
      ROUTE → /cook:auto:fast
    ELIF keywords contains ["parallel"] OR count(extractFeatures(input)) >= 3:
      ROUTE → /cook:auto:parallel
    ELSE:
      ROUTE → /cook:auto

  # Priority 3: Default interactive workflow
  RETURN "interactive"  # Full workflow with review gates (handled by cook skill)
```

## Feature Extraction

Detect multiple features from natural language:

```
"implement auth, payments, and notifications" → ["auth", "payments", "notifications"]
"add login + signup + password reset"        → ["login", "signup", "password reset"]
"create dashboard with charts and tables"    → single feature (dashboard)
```

**Parallel trigger:** 3+ distinct features + auto keywords = `/cook:auto:parallel`

## Routing Summary

| Detection | Route | Behavior |
|-----------|-------|----------|
| Plan path detected | cook skill (code mode) | Execute existing plan with review gates |
| "auto" + "fast"/"quick" | `/cook:auto:fast` | Analyze→plan:fast→implement (no research, no review) |
| "auto" + "parallel" or 3+ features | `/cook:auto:parallel` | Plan:parallel→multi-agent→test→review→docs |
| "auto"/"trust me"/"yolo" | `/cook:auto` | Plan→implement→test→review→commit (auto-approve) |
| Default | cook skill (interactive) | Full workflow with review gates |

## Examples

```
"/cook implement user auth"
→ interactive (default, stops at review gates)

"/cook plans/260120-auth/phase-02-api.md"
→ code mode (path detected, stops at review gates)

"/cook implement auth, payments, notifications auto"
→ /cook:auto:parallel (3 features + auto keyword)

"/cook implement dashboard trust me quick"
→ /cook:auto:fast ("trust me" + "quick")

"/cook implement everything trust me"
→ /cook:auto ("trust me" keyword, auto-approve)
```

## Conflict Resolution

When multiple signals detected, priority order:
1. Path detection (plan files) → code mode
2. Auto keywords → route to sub-command
3. Default → interactive
