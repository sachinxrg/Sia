import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_entry.freezed.dart';
part 'timetable_entry.g.dart';

@freezed
class TimetableEntry with _$TimetableEntry {
  const factory TimetableEntry({
    int? id,
    required String subject,
    required String dayOfWeek,
    required String startTime,
    required String endTime,
    String? room,
    String? teacher,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _TimetableEntry;

  factory TimetableEntry.fromJson(Map<String, dynamic> json) =>
      _$TimetableEntryFromJson(json);
}
