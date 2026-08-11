// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RawNotification _$RawNotificationFromJson(Map<String, dynamic> json) {
  return _RawNotification.fromJson(json);
}

/// @nodoc
mixin _$RawNotification {
  int? get id => throw _privateConstructorUsedError;
  String get packageName => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String get contentHash => throw _privateConstructorUsedError;
  bool get isProcessed => throw _privateConstructorUsedError;
  DateTime get receivedAt => throw _privateConstructorUsedError;

  /// Serializes this RawNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RawNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RawNotificationCopyWith<RawNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RawNotificationCopyWith<$Res> {
  factory $RawNotificationCopyWith(
          RawNotification value, $Res Function(RawNotification) then) =
      _$RawNotificationCopyWithImpl<$Res, RawNotification>;
  @useResult
  $Res call(
      {int? id,
      String packageName,
      String? title,
      String? body,
      String contentHash,
      bool isProcessed,
      DateTime receivedAt});
}

/// @nodoc
class _$RawNotificationCopyWithImpl<$Res, $Val extends RawNotification>
    implements $RawNotificationCopyWith<$Res> {
  _$RawNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RawNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? packageName = null,
    Object? title = freezed,
    Object? body = freezed,
    Object? contentHash = null,
    Object? isProcessed = null,
    Object? receivedAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      contentHash: null == contentHash
          ? _value.contentHash
          : contentHash // ignore: cast_nullable_to_non_nullable
              as String,
      isProcessed: null == isProcessed
          ? _value.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RawNotificationImplCopyWith<$Res>
    implements $RawNotificationCopyWith<$Res> {
  factory _$$RawNotificationImplCopyWith(_$RawNotificationImpl value,
          $Res Function(_$RawNotificationImpl) then) =
      __$$RawNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String packageName,
      String? title,
      String? body,
      String contentHash,
      bool isProcessed,
      DateTime receivedAt});
}

/// @nodoc
class __$$RawNotificationImplCopyWithImpl<$Res>
    extends _$RawNotificationCopyWithImpl<$Res, _$RawNotificationImpl>
    implements _$$RawNotificationImplCopyWith<$Res> {
  __$$RawNotificationImplCopyWithImpl(
      _$RawNotificationImpl _value, $Res Function(_$RawNotificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of RawNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? packageName = null,
    Object? title = freezed,
    Object? body = freezed,
    Object? contentHash = null,
    Object? isProcessed = null,
    Object? receivedAt = null,
  }) {
    return _then(_$RawNotificationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      contentHash: null == contentHash
          ? _value.contentHash
          : contentHash // ignore: cast_nullable_to_non_nullable
              as String,
      isProcessed: null == isProcessed
          ? _value.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RawNotificationImpl implements _RawNotification {
  const _$RawNotificationImpl(
      {this.id,
      required this.packageName,
      this.title,
      this.body,
      required this.contentHash,
      this.isProcessed = false,
      required this.receivedAt});

  factory _$RawNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$RawNotificationImplFromJson(json);

  @override
  final int? id;
  @override
  final String packageName;
  @override
  final String? title;
  @override
  final String? body;
  @override
  final String contentHash;
  @override
  @JsonKey()
  final bool isProcessed;
  @override
  final DateTime receivedAt;

  @override
  String toString() {
    return 'RawNotification(id: $id, packageName: $packageName, title: $title, body: $body, contentHash: $contentHash, isProcessed: $isProcessed, receivedAt: $receivedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RawNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.contentHash, contentHash) ||
                other.contentHash == contentHash) &&
            (identical(other.isProcessed, isProcessed) ||
                other.isProcessed == isProcessed) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, packageName, title, body,
      contentHash, isProcessed, receivedAt);

  /// Create a copy of RawNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RawNotificationImplCopyWith<_$RawNotificationImpl> get copyWith =>
      __$$RawNotificationImplCopyWithImpl<_$RawNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RawNotificationImplToJson(
      this,
    );
  }
}

abstract class _RawNotification implements RawNotification {
  const factory _RawNotification(
      {final int? id,
      required final String packageName,
      final String? title,
      final String? body,
      required final String contentHash,
      final bool isProcessed,
      required final DateTime receivedAt}) = _$RawNotificationImpl;

  factory _RawNotification.fromJson(Map<String, dynamic> json) =
      _$RawNotificationImpl.fromJson;

  @override
  int? get id;
  @override
  String get packageName;
  @override
  String? get title;
  @override
  String? get body;
  @override
  String get contentHash;
  @override
  bool get isProcessed;
  @override
  DateTime get receivedAt;

  /// Create a copy of RawNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RawNotificationImplCopyWith<_$RawNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
