import '../entities/todo_entity.dart';

/// Domain Layer - Repository Interface
/// 
/// 데이터 저장소에 대한 추상화
/// Data Layer에서 이 인터페이스를 구현함 (의존성 역전 원칙)

abstract class TodoRepository {
  /// Todo 목록을 실시간으로 가져오는 Stream
  Stream<List<TodoEntity>> getTodos();

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
