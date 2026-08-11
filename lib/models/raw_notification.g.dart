// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RawNotificationImpl _$$RawNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$RawNotificationImpl(
      id: (json['id'] as num?)?.toInt(),
      packageName: json['packageName'] as String,
      title: json['title'] as String?,
      body: json['body'] as String?,
      contentHash: json['contentHash'] as String,
      isProcessed: json['isProcessed'] as bool? ?? false,
      receivedAt: DateTime.parse(json['receivedAt'] as String),
    );

Map<String, dynamic> _$$RawNotificationImplToJson(
        _$RawNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packageName': instance.packageName,
      'title': instance.title,
      'body': instance.body,
      'contentHash': instance.contentHash,
      'isProcessed': instance.isProcessed,
      'receivedAt': instance.receivedAt.toIso8601String(),
    };
