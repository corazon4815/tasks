// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoDtoImpl _$$TodoDtoImplFromJson(Map<String, dynamic> json) =>
    _$TodoDtoImpl(
      id: json['id'] as String?,
      title: json['title'] as String,
      isDone: json['isDone'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      description: json['description'] as String?,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$TodoDtoImplToJson(_$TodoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isDone': instance.isDone,
      'isFavorite': instance.isFavorite,
      'description': instance.description,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
