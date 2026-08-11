import 'package:freezed_annotation/freezed_annotation.dart';

part 'classroom_assignment.freezed.dart';
part 'classroom_assignment.g.dart';

@freezed
class ClassroomAssignment with _$ClassroomAssignment {
  const factory ClassroomAssignment({
    int? id,
    required String classroomId,
    required String courseName,
    required String assignmentId,
    required String title,
    String? description,
    DateTime? dueDate,
    String? link,
    @Default('ACTIVE') String state,
    required DateTime lastSyncedAt,
  }) = _ClassroomAssignment;

  factory ClassroomAssignment.fromJson(Map<String, dynamic> json) =>
      _$ClassroomAssignmentFromJson(json);
}
