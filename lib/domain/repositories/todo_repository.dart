import '../entities/todo_entity.dart';

/// Domain Layer - Repository Interface
/// 
/// 데이터 저장소에 대한 추상화
/// Data Layer에서 이 인터페이스를 구현함 (의존성 역전 원칙)

abstract class TodoRepository {
  /// [startAfter] : 이 날짜보다 더 과거의 데이터부터 조회
  /// [limit]      : 한 번에 가져올 개수
  Future<List<TodoEntity>> getTodos({
    DateTime? startAfter,
    int limit = 15,
  });

  /// 새로운 Todo 추가
  Future<void> addTodo(TodoEntity todo);

  /// Todo 상태 업데이트 (완료/즐겨찾기)
  Future<void> updateTodoStatus(
    String id, {
    bool? isDone,
    bool? isFavorite,
  });

  /// Todo 삭제
  Future<void> deleteTodo(String id);
}
