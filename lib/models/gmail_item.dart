import 'package:freezed_annotation/freezed_annotation.dart';

part 'gmail_item.freezed.dart';
part 'gmail_item.g.dart';

@freezed
class GmailItem with _$GmailItem {
  const factory GmailItem({
    int? id,
    required String messageId,
    required String fromAddress,
    String? subject,
    String? snippet,
    required DateTime receivedAt,
    @Default(false) bool isProcessed,
    required DateTime lastSyncedAt,
  }) = _GmailItem;

  factory GmailItem.fromJson(Map<String, dynamic> json) =>
      _$GmailItemFromJson(json);
}
