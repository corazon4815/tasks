// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ToDoModel _$ToDoModelFromJson(Map<String, dynamic> json) {
  return _ToDoModel.fromJson(json);
}

/// @nodoc
mixin _$ToDoModel {
  String? get id => throw _privateConstructorUsedError; // Firestore 문서 ID
  String get title => throw _privateConstructorUsedError;
  bool get isDone => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ToDoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ToDoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToDoModelCopyWith<ToDoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToDoModelCopyWith<$Res> {
  factory $ToDoModelCopyWith(ToDoModel value, $Res Function(ToDoModel) then) =
      _$ToDoModelCopyWithImpl<$Res, ToDoModel>;
  @useResult
  $Res call(
      {String? id,
      String title,
      bool isDone,
      bool isFavorite,
      String? description,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$ToDoModelCopyWithImpl<$Res, $Val extends ToDoModel>
    implements $ToDoModelCopyWith<$Res> {
  _$ToDoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToDoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? isDone = null,
    Object? isFavorite = null,
    Object? description = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToDoModelImplCopyWith<$Res>
    implements $ToDoModelCopyWith<$Res> {
  factory _$$ToDoModelImplCopyWith(
          _$ToDoModelImpl value, $Res Function(_$ToDoModelImpl) then) =
      __$$ToDoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String title,
      bool isDone,
      bool isFavorite,
      String? description,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$$ToDoModelImplCopyWithImpl<$Res>
    extends _$ToDoModelCopyWithImpl<$Res, _$ToDoModelImpl>
    implements _$$ToDoModelImplCopyWith<$Res> {
  __$$ToDoModelImplCopyWithImpl(
      _$ToDoModelImpl _value, $Res Function(_$ToDoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToDoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? isDone = null,
    Object? isFavorite = null,
    Object? description = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ToDoModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ToDoModelImpl implements _ToDoModel {
  const _$ToDoModelImpl(
      {this.id,
      required this.title,
      this.isDone = false,
      this.isFavorite = false,
      this.description,
      @TimestampConverter() required this.createdAt});

  factory _$ToDoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ToDoModelImplFromJson(json);

  @override
  final String? id;
// Firestore 문서 ID
  @override
  final String title;
  @override
  @JsonKey()
  final bool isDone;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  final String? description;
  @override
  @TimestampConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'ToDoModel(id: $id, title: $title, isDone: $isDone, isFavorite: $isFavorite, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToDoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, isDone, isFavorite, description, createdAt);

  /// Create a copy of ToDoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToDoModelImplCopyWith<_$ToDoModelImpl> get copyWith =>
      __$$ToDoModelImplCopyWithImpl<_$ToDoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ToDoModelImplToJson(
      this,
    );
  }
}

abstract class _ToDoModel implements ToDoModel {
  const factory _ToDoModel(
          {final String? id,
          required final String title,
          final bool isDone,
          final bool isFavorite,
          final String? description,
          @TimestampConverter() required final DateTime createdAt}) =
      _$ToDoModelImpl;

  factory _ToDoModel.fromJson(Map<String, dynamic> json) =
      _$ToDoModelImpl.fromJson;

  @override
  String? get id; // Firestore 문서 ID
  @override
  String get title;
  @override
  bool get isDone;
  @override
  bool get isFavorite;
  @override
  String? get description;
  @override
  @TimestampConverter()
  DateTime get createdAt;

  /// Create a copy of ToDoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToDoModelImplCopyWith<_$ToDoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
