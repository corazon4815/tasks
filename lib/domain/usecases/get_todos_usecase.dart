import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Domain Layer - Get Todos UseCase
/// 
/// Todo 목록을 가져오는 비즈니스 로직

class GetTodosUseCase {
  final TodoRepository _repository;

  GetTodosUseCase(this._repository);

  /// UseCase 실행
  /// Repository로부터 Todo 목록을 페이지 단위로 가져옴
  /// 
  /// [startAfter] : 이 createdAt 보다 과거의 데이터부터 조회
  /// [limit]      : 한 번에 가져올 개수
  Future<List<TodoEntity>> call({
    DateTime? startAfter,
    int limit = 15,
  }) {
    return _repository.getTodos(
      startAfter: startAfter,
      limit: limit,
    );
  }
}
