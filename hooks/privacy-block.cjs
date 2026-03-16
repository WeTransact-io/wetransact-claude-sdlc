#!/usr/bin/env node
/**
 * privacy-block.cjs - Block access to sensitive files unless user-approved
 *
 * PRIVACY-based blocking (separate from SIZE-based scout-block)
 * Blocks sensitive files. LLM must get user approval and use APPROVED: prefix.
 *
 * Flow:
 * 1. LLM tries: Read ".env" → BLOCKED
 * 2. LLM asks user for permission
 * 3. User approves
 * 4. LLM retries: Read "APPROVED:.env" → ALLOWED
 *
 * Core logic extracted to lib/privacy-checker.cjs for OpenCode plugin reuse.
 */

(async () => {
  try {
    const path = require('path');

    // Import shared privacy checking logic
    const {
      checkPrivacy,
      isSafeFile,
      isPrivacyBlockDisabled,
      isPrivacySensitive,
      hasApprovalPrefix,
      stripApprovalPrefix,
      extractPaths,
      isSuspiciousPath
    } = require('./lib/privacy-checker.cjs');
    const { isHookEnabled } = require('./lib/ck-config-utils.cjs');

    // Early exit if hook disabled in config
    if (!isHookEnabled('privacy-block')) {
      process.exit(0);
    }

/**
 * Format block message with approval instructions and JSON marker for AskUserQuestion
 * @param {string} filePath - Blocked file path
 * @returns {string} Formatted block message with JSON marker
 */
function formatBlockMessage(filePath) {
  const basename = path.basename(filePath);

  // JSON marker for LLM to parse and use AskUserQuestion tool
  const promptData = {
    type: 'PRIVACY_PROMPT',
    file: filePath,
    basename: basename,
    question: {
      header: 'File Access',
      text: `I need to read "${basename}" which may contain sensitive data (API keys, passwords, tokens). Do you approve?`,
      options: [
        { label: 'Yes, approve access', description: `Allow reading ${basename} this time` },
        { label: 'No, skip this file', description: 'Continue without accessing this file' }
      ]
    }
  };

  return `
\x1b[36mNOTE:\x1b[0m This is not an error - this block protects sensitive data.

\x1b[33mPRIVACY BLOCK\x1b[0m: Sensitive file access requires user approval

  \x1b[33mFile:\x1b[0m ${filePath}

  This file may contain secrets (API keys, passwords, tokens).

\x1b[90m@@PRIVACY_PROMPT_START@@\x1b[0m
${JSON.stringify(promptData, null, 2)}
\x1b[90m@@PRIVACY_PROMPT_END@@\x1b[0m

  \x1b[34mClaude:\x1b[0m Use AskUserQuestion tool with the JSON above, then:
  \x1b[32mIf "Yes":\x1b[0m Use bash to read: cat "${filePath}"
  \x1b[31mIf "No":\x1b[0m  Continue without this file.
`;
}

/**
 * Format approval notice
 * @param {string} filePath - Approved file path
 * @returns {string} Formatted approval notice
 */
function formatApprovalNotice(filePath) {
  return `\x1b[32m✓\x1b[0m Privacy: User-approved access to ${path.basename(filePath)}`;
}

// Main
async function main() {
  let input = '';
  for await (const chunk of process.stdin) {
    input += chunk;
  }

  let hookData;
  try {
    hookData = JSON.parse(input);
  } catch (e) {
    process.exit(0); // Invalid JSON, allow
  }

  const { tool_input: toolInput, tool_name: toolName } = hookData;

  // Use shared privacy checker
  const result = checkPrivacy({
    toolName,
    toolInput,
    options: { allowBash: true }
  });

  // Handle results
  if (result.approved) {
    // User approved - allow with notice
    if (result.suspicious) {
      console.error('\x1b[33mWARN:\x1b[0m Approved path is outside project:', result.filePath);
    }
    console.error(formatApprovalNotice(result.filePath));
    process.exit(0);
  }

  if (result.isBash) {
    // Bash: check for dangerous commands on sensitive files
    const cmd = toolInput.command || '';
    const dangerousCommands = ['cat', 'head', 'tail', 'less', 'more', 'grep', 'awk', 'sed', 'cp', 'mv', 'tee', 'source', 'base64', 'xxd', 'od', 'dd'];
    const hasDangerousCmd = dangerousCommands.some(dc => {
      const regex = new RegExp(`\\b${dc}\\b`, 'i');
      return regex.test(cmd);
    });

    if (hasDangerousCmd) {
      // Block bash commands that read sensitive files
      console.error(formatBlockMessage(result.filePath));
      console.error('\x1b[33mTIP:\x1b[0m Use Read tool instead of bash for file access');
      process.exit(1); // Fail-closed: block operation
    }

    // Allow other bash commands (e.g., test -f, which, etc.)
    console.error(`\x1b[33mWARN:\x1b[0m ${result.reason}`);
    process.exit(0);
  }

  if (result.blocked) {
    // No approval - block
    console.error(formatBlockMessage(result.filePath));
    process.exit(2);
  }

  process.exit(0); // Allow
}

    // Run main only when executed directly (not when required for testing)
    if (require.main === module) {
      const { wrapSecurityHook } = require('./lib/hook-error-handler.cjs');
      const wrappedMain = wrapSecurityHook('privacy-block', main);
      wrappedMain();
    }

    // Export functions for unit testing
    if (typeof module !== 'undefined') {
      module.exports = {
        isSafeFile,
        isPrivacyBlockDisabled,
        isPrivacySensitive,
        hasApprovalPrefix,
        stripApprovalPrefix,
        extractPaths,
      };
    }
  } catch (e) {
    // Use centralized error handler (fail-closed for security hooks)
    const { handleHookError } = require('./lib/hook-error-handler.cjs');
    handleHookError('privacy-block', e);
  }
})();
