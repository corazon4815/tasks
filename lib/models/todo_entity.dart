class ToDoEntity {
  final String title;
  final String? description;
  final bool isFavorite;
  final bool isDone;

  const ToDoEntity({
    required this.title,
    this.description,
    this.isFavorite = false,
    this.isDone = false,
  });

  ToDoEntity copyWith({
    String? title,
    String? description,
    bool? isFavorite,
    bool? isDone,
  }) {
    return ToDoEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isDone: isDone ?? this.isDone,
    );
    }
}
