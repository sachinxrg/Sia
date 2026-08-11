// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimetableEntryImpl _$$TimetableEntryImplFromJson(Map<String, dynamic> json) =>
    _$TimetableEntryImpl(
      id: (json['id'] as num?)?.toInt(),
      subject: json['subject'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      room: json['room'] as String?,
      teacher: json['teacher'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TimetableEntryImplToJson(
        _$TimetableEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'dayOfWeek': instance.dayOfWeek,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'room': instance.room,
      'teacher': instance.teacher,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
