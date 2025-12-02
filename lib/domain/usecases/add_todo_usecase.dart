import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Domain Layer - Add Todo UseCase
/// 
/// Todo를 추가하는 비즈니스 로직
/// createdAt을 자동으로 현재 시간으로 설정

class AddTodoUseCase {
  final TodoRepository _repository;

  AddTodoUseCase(this._repository);

  /// UseCase 실행
  /// 비즈니스 규칙: createdAt이 없으면 현재 시간 설정
  Future<void> call(TodoEntity todo) async {
    // createdAt이 설정되지 않은 경우 현재 시간으로 설정
    final todoWithTime = todo.copyWith(
      createdAt: todo.createdAt,
    );
    
    await _repository.addTodo(todoWithTime);
  }
}
