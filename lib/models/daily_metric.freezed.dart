// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyMetric _$DailyMetricFromJson(Map<String, dynamic> json) {
  return _DailyMetric.fromJson(json);
}

/// @nodoc
mixin _$DailyMetric {
  int? get id => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  int get tasksCreated => throw _privateConstructorUsedError;
  int get tasksCompleted => throw _privateConstructorUsedError;
  int get tasksOverdue => throw _privateConstructorUsedError;
  int get notificationsSent => throw _privateConstructorUsedError;
  int get notificationsActedOn => throw _privateConstructorUsedError;
  double get siaScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this DailyMetric to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyMetricCopyWith<DailyMetric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyMetricCopyWith<$Res> {
  factory $DailyMetricCopyWith(
          DailyMetric value, $Res Function(DailyMetric) then) =
      _$DailyMetricCopyWithImpl<$Res, DailyMetric>;
  @useResult
  $Res call(
      {int? id,
      String date,
      int tasksCreated,
      int tasksCompleted,
      int tasksOverdue,
      int notificationsSent,
      int notificationsActedOn,
      double siaScore,
      DateTime createdAt});
}

/// @nodoc
class _$DailyMetricCopyWithImpl<$Res, $Val extends DailyMetric>
    implements $DailyMetricCopyWith<$Res> {
  _$DailyMetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? date = null,
    Object? tasksCreated = null,
    Object? tasksCompleted = null,
    Object? tasksOverdue = null,
    Object? notificationsSent = null,
    Object? notificationsActedOn = null,
    Object? siaScore = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      tasksCreated: null == tasksCreated
          ? _value.tasksCreated
          : tasksCreated // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      tasksOverdue: null == tasksOverdue
          ? _value.tasksOverdue
          : tasksOverdue // ignore: cast_nullable_to_non_nullable
              as int,
      notificationsSent: null == notificationsSent
          ? _value.notificationsSent
          : notificationsSent // ignore: cast_nullable_to_non_nullable
              as int,
      notificationsActedOn: null == notificationsActedOn
          ? _value.notificationsActedOn
          : notificationsActedOn // ignore: cast_nullable_to_non_nullable
              as int,
      siaScore: null == siaScore
          ? _value.siaScore
          : siaScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyMetricImplCopyWith<$Res>
    implements $DailyMetricCopyWith<$Res> {
  factory _$$DailyMetricImplCopyWith(
          _$DailyMetricImpl value, $Res Function(_$DailyMetricImpl) then) =
      __$$DailyMetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String date,
      int tasksCreated,
      int tasksCompleted,
      int tasksOverdue,
      int notificationsSent,
      int notificationsActedOn,
      double siaScore,
      DateTime createdAt});
}

/// @nodoc
class __$$DailyMetricImplCopyWithImpl<$Res>
    extends _$DailyMetricCopyWithImpl<$Res, _$DailyMetricImpl>
    implements _$$DailyMetricImplCopyWith<$Res> {
  __$$DailyMetricImplCopyWithImpl(
      _$DailyMetricImpl _value, $Res Function(_$DailyMetricImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? date = null,
    Object? tasksCreated = null,
    Object? tasksCompleted = null,
    Object? tasksOverdue = null,
    Object? notificationsSent = null,
    Object? notificationsActedOn = null,
    Object? siaScore = null,
    Object? createdAt = null,
  }) {
    return _then(_$DailyMetricImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      tasksCreated: null == tasksCreated
          ? _value.tasksCreated
          : tasksCreated // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      tasksOverdue: null == tasksOverdue
          ? _value.tasksOverdue
          : tasksOverdue // ignore: cast_nullable_to_non_nullable
              as int,
      notificationsSent: null == notificationsSent
          ? _value.notificationsSent
          : notificationsSent // ignore: cast_nullable_to_non_nullable
              as int,
      notificationsActedOn: null == notificationsActedOn
          ? _value.notificationsActedOn
          : notificationsActedOn // ignore: cast_nullable_to_non_nullable
              as int,
      siaScore: null == siaScore
          ? _value.siaScore
          : siaScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyMetricImpl extends _DailyMetric {
  const _$DailyMetricImpl(
      {this.id,
      required this.date,
      this.tasksCreated = 0,
      this.tasksCompleted = 0,
      this.tasksOverdue = 0,
      this.notificationsSent = 0,
      this.notificationsActedOn = 0,
      this.siaScore = 0.0,
      required this.createdAt})
      : super._();

  factory _$DailyMetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyMetricImplFromJson(json);

  @override
  final int? id;
  @override
  final String date;
  @override
  @JsonKey()
  final int tasksCreated;
  @override
  @JsonKey()
  final int tasksCompleted;
  @override
  @JsonKey()
  final int tasksOverdue;
  @override
  @JsonKey()
  final int notificationsSent;
  @override
  @JsonKey()
  final int notificationsActedOn;
  @override
  @JsonKey()
  final double siaScore;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'DailyMetric(id: $id, date: $date, tasksCreated: $tasksCreated, tasksCompleted: $tasksCompleted, tasksOverdue: $tasksOverdue, notificationsSent: $notificationsSent, notificationsActedOn: $notificationsActedOn, siaScore: $siaScore, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyMetricImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.tasksCreated, tasksCreated) ||
                other.tasksCreated == tasksCreated) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.tasksOverdue, tasksOverdue) ||
                other.tasksOverdue == tasksOverdue) &&
            (identical(other.notificationsSent, notificationsSent) ||
                other.notificationsSent == notificationsSent) &&
            (identical(other.notificationsActedOn, notificationsActedOn) ||
                other.notificationsActedOn == notificationsActedOn) &&
            (identical(other.siaScore, siaScore) ||
                other.siaScore == siaScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      tasksCreated,
      tasksCompleted,
      tasksOverdue,
      notificationsSent,
      notificationsActedOn,
      siaScore,
      createdAt);

  /// Create a copy of DailyMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyMetricImplCopyWith<_$DailyMetricImpl> get copyWith =>
      __$$DailyMetricImplCopyWithImpl<_$DailyMetricImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyMetricImplToJson(
      this,
    );
  }
}

abstract class _DailyMetric extends DailyMetric {
  const factory _DailyMetric(
      {final int? id,
      required final String date,
      final int tasksCreated,
      final int tasksCompleted,
      final int tasksOverdue,
      final int notificationsSent,
      final int notificationsActedOn,
      final double siaScore,
      required final DateTime createdAt}) = _$DailyMetricImpl;
  const _DailyMetric._() : super._();

  factory _DailyMetric.fromJson(Map<String, dynamic> json) =
      _$DailyMetricImpl.fromJson;

  @override
  int? get id;
  @override
  String get date;
  @override
  int get tasksCreated;
  @override
  int get tasksCompleted;
  @override
  int get tasksOverdue;
  @override
  int get notificationsSent;
  @override
  int get notificationsActedOn;
  @override
  double get siaScore;
  @override
  DateTime get createdAt;

  /// Create a copy of DailyMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyMetricImplCopyWith<_$DailyMetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
