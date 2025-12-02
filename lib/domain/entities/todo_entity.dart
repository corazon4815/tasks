/// Domain Layer - Todo Entity
/// 
/// 순수한 비즈니스 로직 모델
/// 외부 의존성(Firestore, Freezed 등)이 없음

class TodoEntity {
  final String? id;
  final String title;
  final bool isDone;
  final bool isFavorite;
  final String? description;
  final DateTime createdAt;

  const TodoEntity({
    this.id,
    required this.title,
    this.isDone = false,
    this.isFavorite = false,
    this.description,
    required this.createdAt,
  });

  /// copyWith 메서드 (불변성 유지)
  TodoEntity copyWith({
    String? id,
    String? title,
    bool? isDone,
    bool? isFavorite,
    String? description,
    DateTime? createdAt,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TodoEntity &&
        other.id == id &&
        other.title == title &&
        other.isDone == isDone &&
        other.isFavorite == isFavorite &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      isDone,
      isFavorite,
      description,
      createdAt,
    );
  }

  @override
  String toString() {
    return 'TodoEntity(id: $id, title: $title, isDone: $isDone, '
        'isFavorite: $isFavorite, description: $description, '
        'createdAt: $createdAt)';
  }
}
