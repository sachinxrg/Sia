// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationLog _$NotificationLogFromJson(Map<String, dynamic> json) {
  return _NotificationLog.fromJson(json);
}

/// @nodoc
mixin _$NotificationLog {
  int? get id => throw _privateConstructorUsedError;
  int get taskId => throw _privateConstructorUsedError;
  String get notificationType => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get scheduledFor => throw _privateConstructorUsedError;
  bool get isSent => throw _privateConstructorUsedError;
  bool get isDismissed => throw _privateConstructorUsedError;
  int get escalationCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationLogCopyWith<NotificationLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationLogCopyWith<$Res> {
  factory $NotificationLogCopyWith(
          NotificationLog value, $Res Function(NotificationLog) then) =
      _$NotificationLogCopyWithImpl<$Res, NotificationLog>;
  @useResult
  $Res call(
      {int? id,
      int taskId,
      String notificationType,
      String message,
      DateTime scheduledFor,
      bool isSent,
      bool isDismissed,
      int escalationCount,
      DateTime createdAt});
}

/// @nodoc
class _$NotificationLogCopyWithImpl<$Res, $Val extends NotificationLog>
    implements $NotificationLogCopyWith<$Res> {
  _$NotificationLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taskId = null,
    Object? notificationType = null,
    Object? message = null,
    Object? scheduledFor = null,
    Object? isSent = null,
    Object? isDismissed = null,
    Object? escalationCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledFor: null == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSent: null == isSent
          ? _value.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool,
      isDismissed: null == isDismissed
          ? _value.isDismissed
          : isDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      escalationCount: null == escalationCount
          ? _value.escalationCount
          : escalationCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationLogImplCopyWith<$Res>
    implements $NotificationLogCopyWith<$Res> {
  factory _$$NotificationLogImplCopyWith(_$NotificationLogImpl value,
          $Res Function(_$NotificationLogImpl) then) =
      __$$NotificationLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int taskId,
      String notificationType,
      String message,
      DateTime scheduledFor,
      bool isSent,
      bool isDismissed,
      int escalationCount,
      DateTime createdAt});
}

/// @nodoc
class __$$NotificationLogImplCopyWithImpl<$Res>
    extends _$NotificationLogCopyWithImpl<$Res, _$NotificationLogImpl>
    implements _$$NotificationLogImplCopyWith<$Res> {
  __$$NotificationLogImplCopyWithImpl(
      _$NotificationLogImpl _value, $Res Function(_$NotificationLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? taskId = null,
    Object? notificationType = null,
    Object? message = null,
    Object? scheduledFor = null,
    Object? isSent = null,
    Object? isDismissed = null,
    Object? escalationCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$NotificationLogImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int,
      notificationType: null == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledFor: null == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSent: null == isSent
          ? _value.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool,
      isDismissed: null == isDismissed
          ? _value.isDismissed
          : isDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      escalationCount: null == escalationCount
          ? _value.escalationCount
          : escalationCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationLogImpl implements _NotificationLog {
  const _$NotificationLogImpl(
      {this.id,
      required this.taskId,
      required this.notificationType,
      required this.message,
      required this.scheduledFor,
      this.isSent = false,
      this.isDismissed = false,
      this.escalationCount = 0,
      required this.createdAt});

  factory _$NotificationLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationLogImplFromJson(json);

  @override
  final int? id;
  @override
  final int taskId;
  @override
  final String notificationType;
  @override
  final String message;
  @override
  final DateTime scheduledFor;
  @override
  @JsonKey()
  final bool isSent;
  @override
  @JsonKey()
  final bool isDismissed;
  @override
  @JsonKey()
  final int escalationCount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'NotificationLog(id: $id, taskId: $taskId, notificationType: $notificationType, message: $message, scheduledFor: $scheduledFor, isSent: $isSent, isDismissed: $isDismissed, escalationCount: $escalationCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.isSent, isSent) || other.isSent == isSent) &&
            (identical(other.isDismissed, isDismissed) ||
                other.isDismissed == isDismissed) &&
            (identical(other.escalationCount, escalationCount) ||
                other.escalationCount == escalationCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, taskId, notificationType,
      message, scheduledFor, isSent, isDismissed, escalationCount, createdAt);

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationLogImplCopyWith<_$NotificationLogImpl> get copyWith =>
      __$$NotificationLogImplCopyWithImpl<_$NotificationLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationLogImplToJson(
      this,
    );
  }
}

abstract class _NotificationLog implements NotificationLog {
  const factory _NotificationLog(
      {final int? id,
      required final int taskId,
      required final String notificationType,
      required final String message,
      required final DateTime scheduledFor,
      final bool isSent,
      final bool isDismissed,
      final int escalationCount,
      required final DateTime createdAt}) = _$NotificationLogImpl;

  factory _NotificationLog.fromJson(Map<String, dynamic> json) =
      _$NotificationLogImpl.fromJson;

  @override
  int? get id;
  @override
  int get taskId;
  @override
  String get notificationType;
  @override
  String get message;
  @override
  DateTime get scheduledFor;
  @override
  bool get isSent;
  @override
  bool get isDismissed;
  @override
  int get escalationCount;
  @override
  DateTime get createdAt;

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationLogImplCopyWith<_$NotificationLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
