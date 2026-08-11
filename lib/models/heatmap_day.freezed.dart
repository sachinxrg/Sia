// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heatmap_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HeatmapDay _$HeatmapDayFromJson(Map<String, dynamic> json) {
  return _HeatmapDay.fromJson(json);
}

/// @nodoc
mixin _$HeatmapDay {
  String get date => throw _privateConstructorUsedError;
  double get siaScore => throw _privateConstructorUsedError;
  int get tasksCompleted => throw _privateConstructorUsedError;
  int get goalsProgressed => throw _privateConstructorUsedError;

  /// Serializes this HeatmapDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeatmapDayCopyWith<HeatmapDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeatmapDayCopyWith<$Res> {
  factory $HeatmapDayCopyWith(
          HeatmapDay value, $Res Function(HeatmapDay) then) =
      _$HeatmapDayCopyWithImpl<$Res, HeatmapDay>;
  @useResult
  $Res call(
      {String date, double siaScore, int tasksCompleted, int goalsProgressed});
}

/// @nodoc
class _$HeatmapDayCopyWithImpl<$Res, $Val extends HeatmapDay>
    implements $HeatmapDayCopyWith<$Res> {
  _$HeatmapDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? siaScore = null,
    Object? tasksCompleted = null,
    Object? goalsProgressed = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      siaScore: null == siaScore
          ? _value.siaScore
          : siaScore // ignore: cast_nullable_to_non_nullable
              as double,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      goalsProgressed: null == goalsProgressed
          ? _value.goalsProgressed
          : goalsProgressed // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeatmapDayImplCopyWith<$Res>
    implements $HeatmapDayCopyWith<$Res> {
  factory _$$HeatmapDayImplCopyWith(
          _$HeatmapDayImpl value, $Res Function(_$HeatmapDayImpl) then) =
      __$$HeatmapDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date, double siaScore, int tasksCompleted, int goalsProgressed});
}

/// @nodoc
class __$$HeatmapDayImplCopyWithImpl<$Res>
    extends _$HeatmapDayCopyWithImpl<$Res, _$HeatmapDayImpl>
    implements _$$HeatmapDayImplCopyWith<$Res> {
  __$$HeatmapDayImplCopyWithImpl(
      _$HeatmapDayImpl _value, $Res Function(_$HeatmapDayImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? siaScore = null,
    Object? tasksCompleted = null,
    Object? goalsProgressed = null,
  }) {
    return _then(_$HeatmapDayImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      siaScore: null == siaScore
          ? _value.siaScore
          : siaScore // ignore: cast_nullable_to_non_nullable
              as double,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      goalsProgressed: null == goalsProgressed
          ? _value.goalsProgressed
          : goalsProgressed // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeatmapDayImpl extends _HeatmapDay {
  const _$HeatmapDayImpl(
      {required this.date,
      this.siaScore = 0.0,
      this.tasksCompleted = 0,
      this.goalsProgressed = 0})
      : super._();

  factory _$HeatmapDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeatmapDayImplFromJson(json);

  @override
  final String date;
  @override
  @JsonKey()
  final double siaScore;
  @override
  @JsonKey()
  final int tasksCompleted;
  @override
  @JsonKey()
  final int goalsProgressed;

  @override
  String toString() {
    return 'HeatmapDay(date: $date, siaScore: $siaScore, tasksCompleted: $tasksCompleted, goalsProgressed: $goalsProgressed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeatmapDayImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.siaScore, siaScore) ||
                other.siaScore == siaScore) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.goalsProgressed, goalsProgressed) ||
                other.goalsProgressed == goalsProgressed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, siaScore, tasksCompleted, goalsProgressed);

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeatmapDayImplCopyWith<_$HeatmapDayImpl> get copyWith =>
      __$$HeatmapDayImplCopyWithImpl<_$HeatmapDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeatmapDayImplToJson(
      this,
    );
  }
}

abstract class _HeatmapDay extends HeatmapDay {
  const factory _HeatmapDay(
      {required final String date,
      final double siaScore,
      final int tasksCompleted,
      final int goalsProgressed}) = _$HeatmapDayImpl;
  const _HeatmapDay._() : super._();

  factory _HeatmapDay.fromJson(Map<String, dynamic> json) =
      _$HeatmapDayImpl.fromJson;

  @override
  String get date;
  @override
  double get siaScore;
  @override
  int get tasksCompleted;
  @override
  int get goalsProgressed;

  /// Create a copy of HeatmapDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeatmapDayImplCopyWith<_$HeatmapDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
