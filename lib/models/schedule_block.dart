import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_block.freezed.dart';
part 'schedule_block.g.dart';

enum BlockType { classBlock, task, breakBlock, goal }

@freezed
class ScheduleBlock with _$ScheduleBlock {
  const factory ScheduleBlock({
    required String title,
    required BlockType type,
    required String startTime,
    required String endTime,
    int? taskId,
    int? goalId,
  }) = _ScheduleBlock;

  factory ScheduleBlock.fromJson(Map<String, dynamic> json) =>
      _$ScheduleBlockFromJson(json);
}
