// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consistency_streak.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConsistencyStreak _$ConsistencyStreakFromJson(Map<String, dynamic> json) {
  return _ConsistencyStreak.fromJson(json);
}

/// @nodoc
mixin _$ConsistencyStreak {
  int? get id => throw _privateConstructorUsedError;
  String get streakType => throw _privateConstructorUsedError;
  int? get goalId => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  String? get lastActiveDate => throw _privateConstructorUsedError;
  String? get streakStartDate => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ConsistencyStreak to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConsistencyStreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConsistencyStreakCopyWith<ConsistencyStreak> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConsistencyStreakCopyWith<$Res> {
  factory $ConsistencyStreakCopyWith(
          ConsistencyStreak value, $Res Function(ConsistencyStreak) then) =
      _$ConsistencyStreakCopyWithImpl<$Res, ConsistencyStreak>;
  @useResult
  $Res call(
      {int? id,
      String streakType,
      int? goalId,
      int currentStreak,
      int longestStreak,
      String? lastActiveDate,
      String? streakStartDate,
      DateTime updatedAt});
}

/// @nodoc
class _$ConsistencyStreakCopyWithImpl<$Res, $Val extends ConsistencyStreak>
    implements $ConsistencyStreakCopyWith<$Res> {
  _$ConsistencyStreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConsistencyStreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? streakType = null,
    Object? goalId = freezed,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActiveDate = freezed,
    Object? streakStartDate = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      streakType: null == streakType
          ? _value.streakType
          : streakType // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: freezed == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as int?,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as String?,
      streakStartDate: freezed == streakStartDate
          ? _value.streakStartDate
          : streakStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConsistencyStreakImplCopyWith<$Res>
    implements $ConsistencyStreakCopyWith<$Res> {
  factory _$$ConsistencyStreakImplCopyWith(_$ConsistencyStreakImpl value,
          $Res Function(_$ConsistencyStreakImpl) then) =
      __$$ConsistencyStreakImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String streakType,
      int? goalId,
      int currentStreak,
      int longestStreak,
      String? lastActiveDate,
      String? streakStartDate,
      DateTime updatedAt});
}

/// @nodoc
class __$$ConsistencyStreakImplCopyWithImpl<$Res>
    extends _$ConsistencyStreakCopyWithImpl<$Res, _$ConsistencyStreakImpl>
    implements _$$ConsistencyStreakImplCopyWith<$Res> {
  __$$ConsistencyStreakImplCopyWithImpl(_$ConsistencyStreakImpl _value,
      $Res Function(_$ConsistencyStreakImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConsistencyStreak
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? streakType = null,
    Object? goalId = freezed,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActiveDate = freezed,
    Object? streakStartDate = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$ConsistencyStreakImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      streakType: null == streakType
          ? _value.streakType
          : streakType // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: freezed == goalId
          ? _value.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as int?,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as String?,
      streakStartDate: freezed == streakStartDate
          ? _value.streakStartDate
          : streakStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConsistencyStreakImpl extends _ConsistencyStreak {
  const _$ConsistencyStreakImpl(
      {this.id,
      required this.streakType,
      this.goalId,
      this.currentStreak = 0,
      this.longestStreak = 0,
      this.lastActiveDate,
      this.streakStartDate,
      required this.updatedAt})
      : super._();

  factory _$ConsistencyStreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConsistencyStreakImplFromJson(json);

  @override
  final int? id;
  @override
  final String streakType;
  @override
  final int? goalId;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  final String? lastActiveDate;
  @override
  final String? streakStartDate;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ConsistencyStreak(id: $id, streakType: $streakType, goalId: $goalId, currentStreak: $currentStreak, longestStreak: $longestStreak, lastActiveDate: $lastActiveDate, streakStartDate: $streakStartDate, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsistencyStreakImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.streakType, streakType) ||
                other.streakType == streakType) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            (identical(other.streakStartDate, streakStartDate) ||
                other.streakStartDate == streakStartDate) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, streakType, goalId,
      currentStreak, longestStreak, lastActiveDate, streakStartDate, updatedAt);

  /// Create a copy of ConsistencyStreak
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsistencyStreakImplCopyWith<_$ConsistencyStreakImpl> get copyWith =>
      __$$ConsistencyStreakImplCopyWithImpl<_$ConsistencyStreakImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConsistencyStreakImplToJson(
      this,
    );
  }
}

abstract class _ConsistencyStreak extends ConsistencyStreak {
  const factory _ConsistencyStreak(
      {final int? id,
      required final String streakType,
      final int? goalId,
      final int currentStreak,
      final int longestStreak,
      final String? lastActiveDate,
      final String? streakStartDate,
      required final DateTime updatedAt}) = _$ConsistencyStreakImpl;
  const _ConsistencyStreak._() : super._();

  factory _ConsistencyStreak.fromJson(Map<String, dynamic> json) =
      _$ConsistencyStreakImpl.fromJson;

  @override
  int? get id;
  @override
  String get streakType;
  @override
  int? get goalId;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  String? get lastActiveDate;
  @override
  String? get streakStartDate;
  @override
  DateTime get updatedAt;

  /// Create a copy of ConsistencyStreak
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConsistencyStreakImplCopyWith<_$ConsistencyStreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
