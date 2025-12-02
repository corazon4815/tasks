import '../repositories/todo_repository.dart';

/// Domain Layer - Delete Todo UseCase
/// 
/// Todo를 삭제하는 비즈니스 로직

class DeleteTodoUseCase {
  final TodoRepository _repository;

  DeleteTodoUseCase(this._repository);

  /// UseCase 실행
  /// 비즈니스 규칙: id가 비어있으면 실행하지 않음
  Future<void> call(String id) async {
    if (id.isEmpty) return;
    
    await _repository.deleteTodo(id);
  }
}
