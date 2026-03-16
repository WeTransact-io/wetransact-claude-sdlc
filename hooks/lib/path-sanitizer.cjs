/**
 * Path Sanitization Utilities
 *
 * Provides safe path sanitization for file system operations.
 * Removes dangerous characters and prevents path traversal attacks.
 */

/**
 * Sanitize input for use in file paths
 *
 * Removes or replaces characters that are invalid in file paths:
 * - Windows reserved: < > : " / \ | ? *
 * - Control characters: 0x00-0x1F
 * - Leading dots (hidden files)
 * - Path traversal: ..
 * - Excessive whitespace
 *
 * @param {string} input - The input string to sanitize
 * @param {number} maxLength - Maximum length (default: 255)
 * @returns {string} - Sanitized string safe for use in paths
 */
function sanitizeForPath(input, maxLength = 255) {
  if (!input || typeof input !== 'string') {
    return 'unknown';
  }

  // Trim and limit length
  let sanitized = input.trim().substring(0, maxLength);

  // Replace dangerous characters with underscore
  sanitized = sanitized.replace(/[<>:"/\\|?*\x00-\x1f]/g, '_');

  // Replace leading dots
  sanitized = sanitized.replace(/^\.+/, '_');

  // Replace path traversal sequences
  sanitized = sanitized.replace(/\.\./g, '_');

  // Collapse multiple spaces into single underscore
  sanitized = sanitized.replace(/\s+/g, '_');

  // Fallback if sanitization resulted in empty string
  if (!sanitized) {
    return 'sanitized_' + Date.now();
  }

  return sanitized;
}

/**
 * Sanitize session ID for use in file paths
 *
 * @param {string} id - The session ID to sanitize
 * @returns {string} - Sanitized session ID (max 64 chars)
 */
function sanitizeSessionId(id) {
  return sanitizeForPath(id, 64);
}

module.exports = { sanitizeForPath, sanitizeSessionId };
