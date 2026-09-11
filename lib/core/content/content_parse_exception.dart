/// Raised by [ContentBundleParser] when a content file cannot be decoded.
///
/// Carries enough context (file, entity id) for an author to locate the
/// offending JSON without a stack trace.
class ContentParseException implements Exception {
  const ContentParseException({
    required this.file,
    required this.message,
    this.entityId,
    this.cause,
  });

  /// Path (or label) of the content file being parsed.
  final String file;

  /// Id of the item / card / section that failed, when it could be determined.
  final String? entityId;

  /// Human-readable description of the problem.
  final String message;

  /// Underlying error, if any (a `FormatException`, `CheckedFromJsonException`,
  /// `TypeError`...).
  final Object? cause;

  @override
  String toString() {
    final where = entityId == null ? file : '$file [$entityId]';
    final because = cause == null ? '' : ' ($cause)';
    return 'ContentParseException: $where: $message$because';
  }
}
