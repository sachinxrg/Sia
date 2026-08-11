// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom_assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClassroomAssignment _$ClassroomAssignmentFromJson(Map<String, dynamic> json) {
  return _ClassroomAssignment.fromJson(json);
}

/// @nodoc
mixin _$ClassroomAssignment {
  int? get id => throw _privateConstructorUsedError;
  String get classroomId => throw _privateConstructorUsedError;
  String get courseName => throw _privateConstructorUsedError;
  String get assignmentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  DateTime get lastSyncedAt => throw _privateConstructorUsedError;

  /// Serializes this ClassroomAssignment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClassroomAssignment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassroomAssignmentCopyWith<ClassroomAssignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassroomAssignmentCopyWith<$Res> {
  factory $ClassroomAssignmentCopyWith(
          ClassroomAssignment value, $Res Function(ClassroomAssignment) then) =
      _$ClassroomAssignmentCopyWithImpl<$Res, ClassroomAssignment>;
  @useResult
  $Res call(
      {int? id,
      String classroomId,
      String courseName,
      String assignmentId,
      String title,
      String? description,
      DateTime? dueDate,
      String? link,
      String state,
      DateTime lastSyncedAt});
}

/// @nodoc
class _$ClassroomAssignmentCopyWithImpl<$Res, $Val extends ClassroomAssignment>
    implements $ClassroomAssignmentCopyWith<$Res> {
  _$ClassroomAssignmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassroomAssignment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? classroomId = null,
    Object? courseName = null,
    Object? assignmentId = null,
    Object? title = null,
    Object? description = freezed,
    Object? dueDate = freezed,
    Object? link = freezed,
    Object? state = null,
    Object? lastSyncedAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      classroomId: null == classroomId
          ? _value.classroomId
          : classroomId // ignore: cast_nullable_to_non_nullable
              as String,
      courseName: null == courseName
          ? _value.courseName
          : courseName // ignore: cast_nullable_to_non_nullable
              as String,
      assignmentId: null == assignmentId
          ? _value.assignmentId
          : assignmentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncedAt: null == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClassroomAssignmentImplCopyWith<$Res>
    implements $ClassroomAssignmentCopyWith<$Res> {
  factory _$$ClassroomAssignmentImplCopyWith(_$ClassroomAssignmentImpl value,
          $Res Function(_$ClassroomAssignmentImpl) then) =
      __$$ClassroomAssignmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String classroomId,
      String courseName,
      String assignmentId,
      String title,
      String? description,
      DateTime? dueDate,
      String? link,
      String state,
      DateTime lastSyncedAt});
}

/// @nodoc
class __$$ClassroomAssignmentImplCopyWithImpl<$Res>
    extends _$ClassroomAssignmentCopyWithImpl<$Res, _$ClassroomAssignmentImpl>
    implements _$$ClassroomAssignmentImplCopyWith<$Res> {
  __$$ClassroomAssignmentImplCopyWithImpl(_$ClassroomAssignmentImpl _value,
      $Res Function(_$ClassroomAssignmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClassroomAssignment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? classroomId = null,
    Object? courseName = null,
    Object? assignmentId = null,
    Object? title = null,
    Object? description = freezed,
    Object? dueDate = freezed,
    Object? link = freezed,
    Object? state = null,
    Object? lastSyncedAt = null,
  }) {
    return _then(_$ClassroomAssignmentImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      classroomId: null == classroomId
          ? _value.classroomId
          : classroomId // ignore: cast_nullable_to_non_nullable
              as String,
      courseName: null == courseName
          ? _value.courseName
          : courseName // ignore: cast_nullable_to_non_nullable
              as String,
      assignmentId: null == assignmentId
          ? _value.assignmentId
          : assignmentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      lastSyncedAt: null == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClassroomAssignmentImpl implements _ClassroomAssignment {
  const _$ClassroomAssignmentImpl(
      {this.id,
      required this.classroomId,
      required this.courseName,
      required this.assignmentId,
      required this.title,
      this.description,
      this.dueDate,
      this.link,
      this.state = 'ACTIVE',
      required this.lastSyncedAt});

  factory _$ClassroomAssignmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClassroomAssignmentImplFromJson(json);

  @override
  final int? id;
  @override
  final String classroomId;
  @override
  final String courseName;
  @override
  final String assignmentId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime? dueDate;
  @override
  final String? link;
  @override
  @JsonKey()
  final String state;
  @override
  final DateTime lastSyncedAt;

  @override
  String toString() {
    return 'ClassroomAssignment(id: $id, classroomId: $classroomId, courseName: $courseName, assignmentId: $assignmentId, title: $title, description: $description, dueDate: $dueDate, link: $link, state: $state, lastSyncedAt: $lastSyncedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassroomAssignmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.classroomId, classroomId) ||
                other.classroomId == classroomId) &&
            (identical(other.courseName, courseName) ||
                other.courseName == courseName) &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, classroomId, courseName,
      assignmentId, title, description, dueDate, link, state, lastSyncedAt);

  /// Create a copy of ClassroomAssignment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassroomAssignmentImplCopyWith<_$ClassroomAssignmentImpl> get copyWith =>
      __$$ClassroomAssignmentImplCopyWithImpl<_$ClassroomAssignmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClassroomAssignmentImplToJson(
      this,
    );
  }
}

abstract class _ClassroomAssignment implements ClassroomAssignment {
  const factory _ClassroomAssignment(
      {final int? id,
      required final String classroomId,
      required final String courseName,
      required final String assignmentId,
      required final String title,
      final String? description,
      final DateTime? dueDate,
      final String? link,
      final String state,
      required final DateTime lastSyncedAt}) = _$ClassroomAssignmentImpl;

  factory _ClassroomAssignment.fromJson(Map<String, dynamic> json) =
      _$ClassroomAssignmentImpl.fromJson;

  @override
  int? get id;
  @override
  String get classroomId;
  @override
  String get courseName;
  @override
  String get assignmentId;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime? get dueDate;
  @override
  String? get link;
  @override
  String get state;
  @override
  DateTime get lastSyncedAt;

  /// Create a copy of ClassroomAssignment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassroomAssignmentImplCopyWith<_$ClassroomAssignmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
