// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScheduleBlock _$ScheduleBlockFromJson(Map<String, dynamic> json) {
  return _ScheduleBlock.fromJson(json);
}

/// @nodoc
mixin _$ScheduleBlock {
  String get title => throw _privateConstructorUsedError;
  BlockType get type => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  int? get taskId => throw _privateConstructorUsedError;
  int? get goalId => throw _privateConstructorUsedError;

  /// Serializes this ScheduleBlock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleBlockCopyWith<ScheduleBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleBlockCopyWith<$Res> {
  factory $ScheduleBlockCopyWith(
          ScheduleBlock value, $Res Function(ScheduleBlock) then) =
      _$ScheduleBlockCopyWithImpl<$Res, ScheduleBlock>;
  @useResult
  $Res call(
      {String title,
      BlockType type,
      String startTime,
      String endTime,
      int? taskId,
      int? goalId});
}

/// @nodoc
class _$ScheduleBlockCopyWithImpl<$Res, $Val extends ScheduleBlock>
    implements $ScheduleBlockCopyWith<$Res> {
  _$ScheduleBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? taskId = freezed,
    Object? goalId = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BlockType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      goalId: freezed == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleBlockImplCopyWith<$Res>
    implements $ScheduleBlockCopyWith<$Res> {
  factory _$$ScheduleBlockImplCopyWith(
          _$ScheduleBlockImpl value, $Res Function(_$ScheduleBlockImpl) then) =
      __$$ScheduleBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      BlockType type,
      String startTime,
      String endTime,
      int? taskId,
      int? goalId});
}

/// @nodoc
class __$$ScheduleBlockImplCopyWithImpl<$Res>
    extends _$ScheduleBlockCopyWithImpl<$Res, _$ScheduleBlockImpl>
    implements _$$ScheduleBlockImplCopyWith<$Res> {
  __$$ScheduleBlockImplCopyWithImpl(
      _$ScheduleBlockImpl _value, $Res Function(_$ScheduleBlockImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? taskId = freezed,
    Object? goalId = freezed,
  }) {
    return _then(_$ScheduleBlockImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BlockType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      goalId: freezed == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleBlockImpl implements _ScheduleBlock {
  const _$ScheduleBlockImpl(
      {required this.title,
      required this.type,
      required this.startTime,
      required this.endTime,
      this.taskId,
      this.goalId});

  factory _$ScheduleBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleBlockImplFromJson(json);

  @override
  final String title;
  @override
  final BlockType type;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final int? taskId;
  @override
  final int? goalId;

  @override
  String toString() {
    return 'ScheduleBlock(title: $title, type: $type, startTime: $startTime, endTime: $endTime, taskId: $taskId, goalId: $goalId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleBlockImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.goalId, goalId) || other.goalId == goalId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, type, startTime, endTime, taskId, goalId);

  /// Create a copy of ScheduleBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleBlockImplCopyWith<_$ScheduleBlockImpl> get copyWith =>
      __$$ScheduleBlockImplCopyWithImpl<_$ScheduleBlockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleBlockImplToJson(
      this,
    );
  }
}

abstract class _ScheduleBlock implements ScheduleBlock {
  const factory _ScheduleBlock(
      {required final String title,
      required final BlockType type,
      required final String startTime,
      required final String endTime,
      final int? taskId,
      final int? goalId}) = _$ScheduleBlockImpl;

  factory _ScheduleBlock.fromJson(Map<String, dynamic> json) =
      _$ScheduleBlockImpl.fromJson;

  @override
  String get title;
  @override
  BlockType get type;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  int? get taskId;
  @override
  int? get goalId;

  /// Create a copy of ScheduleBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleBlockImplCopyWith<_$ScheduleBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
