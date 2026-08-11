import 'package:freezed_annotation/freezed_annotation.dart';

part 'raw_notification.freezed.dart';
part 'raw_notification.g.dart';

@freezed
class RawNotification with _$RawNotification {
  const factory RawNotification({
    int? id,
    required String packageName,
    String? title,
    String? body,
    required String contentHash,
    @Default(false) bool isProcessed,
    required DateTime receivedAt,
  }) = _RawNotification;

  factory RawNotification.fromJson(Map<String, dynamic> json) =>
      _$RawNotificationFromJson(json);
}
