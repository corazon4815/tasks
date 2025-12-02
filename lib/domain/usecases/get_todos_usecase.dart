import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Domain Layer - Get Todos UseCase
/// 
/// Todo 목록을 가져오는 비즈니스 로직

class GetTodosUseCase {
  final TodoRepository _repository;

  GetTodosUseCase(this._repository);

  /// UseCase 실행
  /// Repository로부터 Todo 목록을 Stream으로 반환
  Stream<List<TodoEntity>> call() {
    return _repository.getTodos();
  }
}
