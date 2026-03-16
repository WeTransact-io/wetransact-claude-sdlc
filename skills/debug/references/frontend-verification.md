# Frontend Verification

Visual verification of frontend implementations using `playwright-cli` skill.

## Applicability Check

**Skip entirely if task is NOT frontend-related.** Frontend indicators:
- Files modified: `*.tsx`, `*.jsx`, `*.vue`, `*.svelte`, `*.html`, `*.css`, `*.scss`
- Changes to: components, layouts, pages, styles, DOM structure, UI behavior
- Keywords: render, display, layout, responsive, animation, visual, UI, UX

If none match, skip this technique.

## Step 1: Verify with playwright-cli

Ensure dev server is running, then use `playwright-cli` skill:

```bash
# Open browser and navigate
playwright-cli open http://localhost:3000

# Screenshot
playwright-cli screenshot --filename=./verification-screenshot.png

# Console error check
playwright-cli console error

# Snapshot for DOM/accessibility inspection
playwright-cli snapshot

# Close when done
playwright-cli close
```

If `playwright-cli` is unavailable, skip visual verification and note in report:
> "Visual verification skipped — no playwright-cli available."

## Step 2: Analyze Results

After capture:
1. **Read screenshot** — Use Read tool on the PNG to visually inspect
2. **Check console output** — Zero errors = pass; errors = investigate before claiming done
3. **Compare with expected** — Match against design specs or user description
4. **Document findings** — Include screenshot path and any issues found in verification report

## Integration with Verification Protocol

This technique extends `verification.md`. After standard verification (tests pass, build succeeds), add frontend verification as final gate:

```
Standard verification → Tests pass → Build succeeds → Frontend visual verification → Claim complete
```

Report format:
```
## Frontend Verification
- Method: [playwright-cli | skipped]
- Screenshot: ./verification-screenshot.png
- Console errors: [none | list]
- Visual check: [pass | issues found]
- Responsive: [checked at X viewports | skipped]
```
