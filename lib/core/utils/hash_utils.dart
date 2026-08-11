import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Generates a SHA-256 hash for notification deduplication.
/// Combines packageName + title + text, normalizing within a 2-minute window.
String generateNotificationHash({
  required String packageName,
  required String? title,
  required String? body,
  required DateTime timestamp,
}) {
  // Round timestamp to nearest 2-minute window for dedup tolerance
  final windowedTimestamp = DateTime(
    timestamp.year,
    timestamp.month,
    timestamp.day,
    timestamp.hour,
    (timestamp.minute ~/ 2) * 2,
  );

  final content =
      '$packageName|${title ?? ''}|${body ?? ''}|${windowedTimestamp.toIso8601String()}';
  final bytes = utf8.encode(content);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
