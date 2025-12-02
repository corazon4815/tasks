import '../repositories/todo_repository.dart';

/// Domain Layer - Update Todo Status UseCase
/// 
/// Todo의 상태(완료/즐겨찾기)를 업데이트하는 비즈니스 로직

class UpdateTodoStatusUseCase {
  final TodoRepository _repository;

  UpdateTodoStatusUseCase(this._repository);

  /// UseCase 실행
  /// isDone 또는 isFavorite 중 하나 이상의 상태를 업데이트
  Future<void> call(
    String id, {
    bool? isDone,
    bool? isFavorite,
  }) async {
    // 비즈니스 규칙: id가 비어있으면 실행하지 않음
    if (id.isEmpty) return;
    
    await _repository.updateTodoStatus(
      id,
      isDone: isDone,
      isFavorite: isFavorite,
    );
  }
}
