import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/todo_entity.dart';

part 'todo_dto.freezed.dart';
part 'todo_dto.g.dart';

/// Data Layer - Todo DTO (Data Transfer Object)
/// 
/// Firestore와 Domain Entity 사이의 변환을 담당
/// Freezed를 사용하여 불변성과 직렬화 제공

/// Timestamp ↔ DateTime 변환기
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}

@freezed
class TodoDto with _$TodoDto {
  const TodoDto._();

  const factory TodoDto({
    String? id,
    required String title,
    @Default(false) bool isDone,
    @Default(false) bool isFavorite,
    String? description,
    @TimestampConverter() required DateTime createdAt,
  }) = _TodoDto;

  /// Firestore DocumentSnapshot → DTO
  factory TodoDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Document data was null.');

    return TodoDto.fromJson(data).copyWith(id: doc.id);
  }

  /// JSON → DTO
  factory TodoDto.fromJson(Map<String, dynamic> json) => _$TodoDtoFromJson(json);

  /// DTO → Entity (Domain으로 변환)
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      isDone: isDone,
      isFavorite: isFavorite,
      description: description,
      createdAt: createdAt,
    );
  }

  /// Entity → DTO (Domain에서 변환)
  factory TodoDto.fromEntity(TodoEntity entity) {
    return TodoDto(
      id: entity.id,
      title: entity.title,
      isDone: entity.isDone,
      isFavorite: entity.isFavorite,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }

  /// DTO → Firestore (저장용)
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Firestore는 id를 별도로 관리
    return json;
  }
}
