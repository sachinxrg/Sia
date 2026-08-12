import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_block.freezed.dart';
part 'timeline_block.g.dart';

@freezed
class TimelineBlock with _$TimelineBlock {
  const TimelineBlock._();

  const factory TimelineBlock({
    required String title,
    required String type,
    required String startTime,
    required String endTime,
    int? taskId,
    int? goalId,
    String? subtitle,
    String? colorHex,
    @Default(false) bool isFixed,
    @Default(false) bool isCurrent,
  }) = _TimelineBlock;

  factory TimelineBlock.fromJson(Map<String, dynamic> json) =>
      _$TimelineBlockFromJson(json);

  /// Parses the start time string (HH:mm) to a TimeOfDay.
  TimeOfDay get startTimeOfDay {
    final parts = startTime.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// Parses the end time string (HH:mm) to a TimeOfDay.
  TimeOfDay get endTimeOfDay {
    final parts = endTime.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// Duration in minutes.
  int get durationMinutes {
    final start = startTimeOfDay;
    final end = endTimeOfDay;
    return (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute);
  }
}
