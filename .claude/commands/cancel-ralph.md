---
description: "Cancel active Ralph Loop"
allowed-tools: ["Bash(*ralph-loop.local.md*)"]
hide-from-slash-command-tool: "true"
---

# Cancel Ralph

To cancel the Ralph loop:

1. Resolve the project root and check if the state file exists using Bash:
   ```
   PROJECT=$(d="$PWD"; while [ ! -d "$d/.claude" ] && [ "$d" != "/" ]; do d="$(dirname "$d")"; done; echo "$d") && test -f "$PROJECT/.claude/ralph-loop.local.md" && echo "EXISTS" || echo "NOT_FOUND"
   ```

2. **If NOT_FOUND**: Say "No active Ralph loop found."

3. **If EXISTS**:
   - Read `"$PROJECT/.claude/ralph-loop.local.md"` to get the current iteration number from the `iteration:` field
   - Remove the file using Bash:
     ```
     PROJECT=$(d="$PWD"; while [ ! -d "$d/.claude" ] && [ "$d" != "/" ]; do d="$(dirname "$d")"; done; echo "$d") && rm "$PROJECT/.claude/ralph-loop.local.md"
     ```
   - Report: "Cancelled Ralph loop (was at iteration N)" where N is the iteration value
