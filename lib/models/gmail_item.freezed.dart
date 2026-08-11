// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gmail_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GmailItem _$GmailItemFromJson(Map<String, dynamic> json) {
  return _GmailItem.fromJson(json);
}

/// @nodoc
mixin _$GmailItem {
  int? get id => throw _privateConstructorUsedError;
  String get messageId => throw _privateConstructorUsedError;
  String get fromAddress => throw _privateConstructorUsedError;
  String? get subject => throw _privateConstructorUsedError;
  String? get snippet => throw _privateConstructorUsedError;
  DateTime get receivedAt => throw _privateConstructorUsedError;
  bool get isProcessed => throw _privateConstructorUsedError;
  DateTime get lastSyncedAt => throw _privateConstructorUsedError;

  /// Serializes this GmailItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GmailItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GmailItemCopyWith<GmailItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GmailItemCopyWith<$Res> {
  factory $GmailItemCopyWith(GmailItem value, $Res Function(GmailItem) then) =
      _$GmailItemCopyWithImpl<$Res, GmailItem>;
  @useResult
  $Res call(
      {int? id,
      String messageId,
      String fromAddress,
      String? subject,
      String? snippet,
      DateTime receivedAt,
      bool isProcessed,
      DateTime lastSyncedAt});
}

/// @nodoc
class _$GmailItemCopyWithImpl<$Res, $Val extends GmailItem>
    implements $GmailItemCopyWith<$Res> {
  _$GmailItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GmailItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? messageId = null,
    Object? fromAddress = null,
    Object? subject = freezed,
    Object? snippet = freezed,
    Object? receivedAt = null,
    Object? isProcessed = null,
    Object? lastSyncedAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      fromAddress: null == fromAddress
          ? _value.fromAddress
          : fromAddress // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      snippet: freezed == snippet
          ? _value.snippet
          : snippet // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isProcessed: null == isProcessed
          ? _value.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncedAt: null == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GmailItemImplCopyWith<$Res>
    implements $GmailItemCopyWith<$Res> {
  factory _$$GmailItemImplCopyWith(
          _$GmailItemImpl value, $Res Function(_$GmailItemImpl) then) =
      __$$GmailItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String messageId,
      String fromAddress,
      String? subject,
      String? snippet,
      DateTime receivedAt,
      bool isProcessed,
      DateTime lastSyncedAt});
}

/// @nodoc
class __$$GmailItemImplCopyWithImpl<$Res>
    extends _$GmailItemCopyWithImpl<$Res, _$GmailItemImpl>
    implements _$$GmailItemImplCopyWith<$Res> {
  __$$GmailItemImplCopyWithImpl(
      _$GmailItemImpl _value, $Res Function(_$GmailItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of GmailItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? messageId = null,
    Object? fromAddress = null,
    Object? subject = freezed,
    Object? snippet = freezed,
    Object? receivedAt = null,
    Object? isProcessed = null,
    Object? lastSyncedAt = null,
  }) {
    return _then(_$GmailItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      fromAddress: null == fromAddress
          ? _value.fromAddress
          : fromAddress // ignore: cast_nullable_to_non_nullable
              as String,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String?,
      snippet: freezed == snippet
          ? _value.snippet
          : snippet // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isProcessed: null == isProcessed
          ? _value.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncedAt: null == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GmailItemImpl implements _GmailItem {
  const _$GmailItemImpl(
      {this.id,
      required this.messageId,
      required this.fromAddress,
      this.subject,
      this.snippet,
      required this.receivedAt,
      this.isProcessed = false,
      required this.lastSyncedAt});

  factory _$GmailItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$GmailItemImplFromJson(json);

  @override
  final int? id;
  @override
  final String messageId;
  @override
  final String fromAddress;
  @override
  final String? subject;
  @override
  final String? snippet;
  @override
  final DateTime receivedAt;
  @override
  @JsonKey()
  final bool isProcessed;
  @override
  final DateTime lastSyncedAt;

  @override
  String toString() {
    return 'GmailItem(id: $id, messageId: $messageId, fromAddress: $fromAddress, subject: $subject, snippet: $snippet, receivedAt: $receivedAt, isProcessed: $isProcessed, lastSyncedAt: $lastSyncedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GmailItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.fromAddress, fromAddress) ||
                other.fromAddress == fromAddress) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.snippet, snippet) || other.snippet == snippet) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.isProcessed, isProcessed) ||
                other.isProcessed == isProcessed) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, messageId, fromAddress,
      subject, snippet, receivedAt, isProcessed, lastSyncedAt);

  /// Create a copy of GmailItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GmailItemImplCopyWith<_$GmailItemImpl> get copyWith =>
      __$$GmailItemImplCopyWithImpl<_$GmailItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GmailItemImplToJson(
      this,
    );
  }
}

abstract class _GmailItem implements GmailItem {
  const factory _GmailItem(
      {final int? id,
      required final String messageId,
      required final String fromAddress,
      final String? subject,
      final String? snippet,
      required final DateTime receivedAt,
      final bool isProcessed,
      required final DateTime lastSyncedAt}) = _$GmailItemImpl;

  factory _GmailItem.fromJson(Map<String, dynamic> json) =
      _$GmailItemImpl.fromJson;

  @override
  int? get id;
  @override
  String get messageId;
  @override
  String get fromAddress;
  @override
  String? get subject;
  @override
  String? get snippet;
  @override
  DateTime get receivedAt;
  @override
  bool get isProcessed;
  @override
  DateTime get lastSyncedAt;

  /// Create a copy of GmailItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GmailItemImplCopyWith<_$GmailItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
