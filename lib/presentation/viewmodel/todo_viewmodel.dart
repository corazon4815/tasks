import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/update_todo_status_usecase.dart';
import '../../core/providers.dart';

part 'todo_viewmodel.g.dart';

/**
 * Clean Architecture - ViewModel
 * 
 * - Domain Layer의 UseCase만 사용
 * - Repository나 DataSource에 직접 접근하지 않음
 * - 비즈니스 로직은 UseCase에 위임
 */
@riverpod
class TodoViewModel extends _$TodoViewModel {
  late final GetTodosUseCase _getTodosUseCase;
  late final AddTodoUseCase _addTodoUseCase;
  late final UpdateTodoStatusUseCase _updateTodoStatusUseCase;
  late final DeleteTodoUseCase _deleteTodoUseCase;

  @override
  Stream<List<TodoEntity>> build() {
    // UseCase 의존성 주입
    _getTodosUseCase = ref.watch(getTodosUseCaseProvider);
    _addTodoUseCase = ref.watch(addTodoUseCaseProvider);
    _updateTodoStatusUseCase = ref.watch(updateTodoStatusUseCaseProvider);
    _deleteTodoUseCase = ref.watch(deleteTodoUseCaseProvider);

    // GetTodosUseCase를 통해 Todo 목록 Stream 반환
    return _getTodosUseCase();
  }

  /// Todo 추가
  Future<void> addTodo(TodoEntity newTodo) async {
    await _addTodoUseCase(newTodo);
  }

  /// 완료 상태 토글
  Future<void> toggleDone(TodoEntity todo) async {
    if (todo.id == null) return;
    await _updateTodoStatusUseCase(
      todo.id!,
      isDone: !todo.isDone,
    );
  }

  /// 즐겨찾기 상태 토글
  Future<void> toggleFavorite(TodoEntity todo) async {
    if (todo.id == null) return;
    await _updateTodoStatusUseCase(
      todo.id!,
      isFavorite: !todo.isFavorite,
    );
  }

  /// Todo 삭제
  Future<void> deleteTodo(TodoEntity todo) async {
    if (todo.id == null) return;
    await _deleteTodoUseCase(todo.id!);
  }
}