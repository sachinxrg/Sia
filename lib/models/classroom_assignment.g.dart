// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClassroomAssignmentImpl _$$ClassroomAssignmentImplFromJson(
        Map<String, dynamic> json) =>
    _$ClassroomAssignmentImpl(
      id: (json['id'] as num?)?.toInt(),
      classroomId: json['classroomId'] as String,
      courseName: json['courseName'] as String,
      assignmentId: json['assignmentId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      link: json['link'] as String?,
      state: json['state'] as String? ?? 'ACTIVE',
      lastSyncedAt: DateTime.parse(json['lastSyncedAt'] as String),
    );

Map<String, dynamic> _$$ClassroomAssignmentImplToJson(
        _$ClassroomAssignmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classroomId': instance.classroomId,
      'courseName': instance.courseName,
      'assignmentId': instance.assignmentId,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate?.toIso8601String(),
      'link': instance.link,
      'state': instance.state,
      'lastSyncedAt': instance.lastSyncedAt.toIso8601String(),
    };
