// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gmail_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GmailItemImpl _$$GmailItemImplFromJson(Map<String, dynamic> json) =>
    _$GmailItemImpl(
      id: (json['id'] as num?)?.toInt(),
      messageId: json['messageId'] as String,
      fromAddress: json['fromAddress'] as String,
      subject: json['subject'] as String?,
      snippet: json['snippet'] as String?,
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      isProcessed: json['isProcessed'] as bool? ?? false,
      lastSyncedAt: DateTime.parse(json['lastSyncedAt'] as String),
    );

Map<String, dynamic> _$$GmailItemImplToJson(_$GmailItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messageId': instance.messageId,
      'fromAddress': instance.fromAddress,
      'subject': instance.subject,
      'snippet': instance.snippet,
      'receivedAt': instance.receivedAt.toIso8601String(),
      'isProcessed': instance.isProcessed,
      'lastSyncedAt': instance.lastSyncedAt.toIso8601String(),
    };
