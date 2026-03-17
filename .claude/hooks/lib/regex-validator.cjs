/**
 * ReDoS Protection Validator
 *
 * Validates regex patterns to prevent Regular Expression Denial of Service (ReDoS) attacks.
 * Enforces limits on pattern complexity and detects dangerous backtracking patterns.
 */

const LIMITS = {
  maxLength: 500,         // Maximum pattern length
  maxQuantifiers: 10,     // Maximum number of quantifiers (*, +, ?, {})
  maxGroups: 5,           // Maximum number of capturing groups
  maxAlternations: 20     // Maximum number of alternations (|)
};

/**
 * Validate a regex pattern for ReDoS vulnerabilities
 *
 * @param {string} pattern - The regex pattern to validate
 * @returns {Object} - { valid: boolean, reason?: string }
 */
function validateRegex(pattern) {
  // Check pattern length
  if (pattern.length > LIMITS.maxLength) {
    return { valid: false, reason: 'Regex too long' };
  }

  // Count quantifiers
  const quantifiers = (pattern.match(/[*+?{]/g) || []).length;
  if (quantifiers > LIMITS.maxQuantifiers) {
    return { valid: false, reason: 'Too many quantifiers' };
  }

  // Count capturing groups
  const groups = (pattern.match(/\(/g) || []).length;
  if (groups > LIMITS.maxGroups) {
    return { valid: false, reason: 'Too many groups' };
  }

  // Detect dangerous backtracking patterns
  const dangerousPatterns = [
    /\(\.\*\)\+/,              // (.*)+
    /\(.*\)\*/,                // (.*)*
    /\([^)]*\+[^)]*\)\+/       // (a+b)+
  ];

  for (const dangerous of dangerousPatterns) {
    if (dangerous.test(pattern)) {
      return { valid: false, reason: 'Dangerous backtracking pattern' };
    }
  }

  // Validate regex syntax
  try {
    new RegExp(pattern);
  } catch (e) {
    return { valid: false, reason: `Invalid: ${e.message}` };
  }

  return { valid: true };
}

module.exports = { validateRegex };
