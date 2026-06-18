/// Normalizes a host string for consistent cache key generation.
///
/// Normalization rules:
/// - Convert to lowercase
/// - Remove `http://` or `https://` scheme prefix
/// - Remove trailing slashes
/// - Preserve port (e.g., `https://server:4533/` -> `server:4533`)
/// - Empty string returns empty string (no exception)
String normalizeHost(String host) {
  if (host.isEmpty) return '';

  var normalized = host.toLowerCase();

  // Remove scheme if present
  if (normalized.startsWith('http://')) {
    normalized = normalized.substring(7);
  } else if (normalized.startsWith('https://')) {
    normalized = normalized.substring(8);
  }

  // Remove trailing slashes
  while (normalized.endsWith('/')) {
    normalized = normalized.substring(0, normalized.length - 1);
  }

  return normalized;
}
