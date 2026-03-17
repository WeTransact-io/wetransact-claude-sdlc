# UI Testing Workflow

Browser-based visual testing using `playwright-cli` skill. Requires `playwright-cli` to be available.

## Prerequisites

```bash
# Open a browser session
playwright-cli open
# Navigate to target
playwright-cli goto http://localhost:3000
```

## Step 1: Discovery

Browse target URL, discover pages, components, endpoints:

```bash
playwright-cli goto http://localhost:3000
playwright-cli snapshot
```

## Step 2: Visual Capture

```bash
# Full page screenshot
playwright-cli screenshot --filename=./screenshots/home.png

# Specific component (use ref from snapshot)
playwright-cli screenshot e5 --filename=./screenshots/component.png
```

## Step 3: Console Error Check

```bash
# Capture JS errors
playwright-cli console error
```

Zero errors = pass. Any errors = investigate before proceeding.

## Step 4: Network Validation

```bash
# Check for failed API calls
playwright-cli network
```

## Step 5: Responsive Testing

Capture at key breakpoints:
```bash
# Desktop
playwright-cli resize 1920 1080
playwright-cli screenshot --filename=./screenshots/responsive-1920x1080.png

# Tablet
playwright-cli resize 768 1024
playwright-cli screenshot --filename=./screenshots/responsive-768x1024.png

# Mobile
playwright-cli resize 375 812
playwright-cli screenshot --filename=./screenshots/responsive-375x812.png

# Reset to desktop
playwright-cli resize 1920 1080
```

## Step 6: Form & Interaction Testing

```bash
# Use refs from snapshot output
playwright-cli fill e1 "test@example.com"
playwright-cli fill e2 "Test123!"
playwright-cli click e3
playwright-cli screenshot --filename=./screenshots/form-submitted.png
```

## Step 7: Performance Metrics

```bash
playwright-cli eval "JSON.stringify(performance.getEntriesByType('navigation')[0])"
```

## Authentication for Protected Routes

For testing pages behind auth:

```bash
# Option A: Inject cookies
playwright-cli cookie-set session abc123 --domain=.site.com --httpOnly --secure

# Option B: Set localStorage token
playwright-cli localstorage-set auth_token "eyJhbG..."

# Option C: Load saved auth state
playwright-cli state-load auth.json
```

After injection, browser session persists. Run tests normally.

## Screenshot Analysis

Analyze captured screenshots visually for:
- Layout correctness
- Visual regressions
- Missing elements
- Broken styling
- Accessibility issues (contrast, text size)

## Parallel Execution

Spawn multiple `e2e-test-executor` subagents in parallel for independent pages/flows to speed up UI testing.

## Cleanup

```bash
# Close browser session when done
playwright-cli close
```
