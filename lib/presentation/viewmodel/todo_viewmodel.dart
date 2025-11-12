
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tasks/data/repository/todo_repository.dart';
import 'package:tasks/models/todo_model.dart';

part 'todo_viewmodel.g.dart';

/**
 * MVVM의 ViewModel
 * - 로직 및 데이터 관리
 * - View의 명령을 받고 Model 조작
 **/
@riverpod
class TodoViewModel extends _$TodoViewModel {
  late final ToDoRepository _repository;

  @override
  Stream<List<ToDoModel>> build() {
    _repository = ref.watch(todoRepositoryProvider);
    return _repository.getTodos();
  }

  Future<void> addTodo(ToDoModel newTodo) async {
    final todoWithTime = newTodo.copyWith(createdAt: DateTime.now());
    await _repository.addTodo(todoWithTime);
  }

  Future<void> toggleDone(ToDoModel todo) async {
    if (todo.id == null) return;
    await _repository.updateTodoStatus(
      todo.id!,
      isDone: !todo.isDone,
    );
  }

  Future<void> toggleFavorite(ToDoModel todo) async {
    if (todo.id == null) return;
    await _repository.updateTodoStatus(
      todo.id!,
      isFavorite: !todo.isFavorite,
    );
  }

  Future<void> deleteTodo(ToDoModel todo) async {
    if (todo.id == null) return;
    await _repository.deleteTodo(todo.id!);
  }
}