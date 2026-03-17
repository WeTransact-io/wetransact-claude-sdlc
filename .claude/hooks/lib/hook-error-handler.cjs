#!/usr/bin/env node
/**
 * hook-error-handler.cjs - Centralized error handling for hooks
 *
 * Provides fail-closed behavior for security hooks and fail-open for others.
 * Security hooks (privacy-block, code-execution-guard, secret-scanner) must
 * fail-closed to prevent bypassing security controls on errors.
 *
 * @module hook-error-handler
 */

/**
 * Set of hooks that must fail-closed (block on error)
 * @type {Set<string>}
 */
const SECURITY_HOOKS = new Set([
  'privacy-block',
  'code-execution-guard',
  'secret-scanner'
]);

/**
 * Handle hook error with appropriate exit code
 * @param {string} hookName - Name of the hook that failed
 * @param {Error} error - Error that occurred
 */
function handleHookError(hookName, error) {
  console.error(`Hook error in ${hookName}: ${error.message}`);

  if (SECURITY_HOOKS.has(hookName)) {
    console.error('SECURITY HOOK FAILED: Blocking for safety');
    process.exit(1); // Fail-closed: block operation
  } else {
    process.exit(0); // Fail-open: allow operation
  }
}

/**
 * Wrap a security hook function with error handling
 * @param {string} hookName - Name of the hook
 * @param {Function} hookFn - Hook function to wrap
 * @returns {Function} Wrapped hook function
 */
function wrapSecurityHook(hookName, hookFn) {
  return async (...args) => {
    try {
      return await hookFn(...args);
    } catch (e) {
      handleHookError(hookName, e);
    }
  };
}

module.exports = {
  handleHookError,
  wrapSecurityHook,
  SECURITY_HOOKS
};
