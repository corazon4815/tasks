import 'package:flutter_riverpod/flutter_riverpod.dart'; // ← AsyncValue를 위해 필요
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/update_todo_status_usecase.dart';
import '../../core/providers.dart';

part 'todo_viewmodel.g.dart';

/// Clean Architecture - ViewModel
/// 
/// - Domain Layer의 UseCase만 사용
/// - Repository나 DataSource에 직접 접근하지 않음
/// - 페이지네이션 + Pull-to-Refresh + Infinite Scroll
@riverpod
class TodoViewModel extends _$TodoViewModel {
  static const int _pageSize = 15; // ← 누락되어 있던 상수

  late final GetTodosUseCase _getTodosUseCase;
  late final AddTodoUseCase _addTodoUseCase;
  late final UpdateTodoStatusUseCase _updateTodoStatusUseCase;
  late final DeleteTodoUseCase _deleteTodoUseCase;

  bool _isLoadingMore = false;
  bool _hasMore = true;
  DateTime? _lastCreatedAt; // 마지막으로 받은 아이템의 createdAt

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<TodoEntity>> build() async {
    // UseCase 의존성 주입
    _getTodosUseCase = ref.watch(getTodosUseCaseProvider);
    _addTodoUseCase = ref.watch(addTodoUseCaseProvider);
    _updateTodoStatusUseCase = ref.watch(updateTodoStatusUseCaseProvider);
    _deleteTodoUseCase = ref.watch(deleteTodoUseCaseProvider);

    return _loadInitial();
  }

  /// 최초 로딩 or 완전 새로고침 시 사용하는 내부 메서드
  Future<List<TodoEntity>> _loadInitial() async {
    _hasMore = true;
    _isLoadingMore = false;
    _lastCreatedAt = null;

    final items = await _getTodosUseCase(
      limit: _pageSize,
      startAfter: null,
    );

    if (items.isNotEmpty) {
      _lastCreatedAt = items.last.createdAt;
      if (items.length < _pageSize) {
        _hasMore = false;
      }
    } else {
      _hasMore = false;
    }

    return items;
  }

  /// Pull to Refresh 에서 호출
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final items = await _loadInitial();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Infinite Scroll에서 하단 근처 도달 시 호출
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    final current = state.value ?? const <TodoEntity>[];

    _isLoadingMore = true;

    try {
      final next = await _getTodosUseCase(
        startAfter: _lastCreatedAt,
        limit: _pageSize,
      );

      if (next.isEmpty) {
        _hasMore = false;
      } else {
        _lastCreatedAt = next.last.createdAt;
        if (next.length < _pageSize) {
          _hasMore = false;
        }
        state = AsyncValue.data([...current, ...next]);
      }
    } catch (e, st) {
      // 기존 데이터는 유지하면서 에러만 알리려면 이렇게 해도 되고,
      // 지금은 그냥 에러 상태로 덮어씀
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Todo 추가
  Future<void> addTodo(TodoEntity newTodo) async {
    await _addTodoUseCase(newTodo);
    // 새로 추가되면 맨 위에 보여야 하니까 다시 로딩
    await refresh();
  }

  /// 완료 상태 토글
  Future<void> toggleDone(TodoEntity todo) async {
    if (todo.id == null) return;
    await _updateTodoStatusUseCase(
      todo.id!,
      isDone: !todo.isDone,
    );
    await refresh();
  }

  /// 즐겨찾기 상태 토글
  Future<void> toggleFavorite(TodoEntity todo) async {
    if (todo.id == null) return;
    await _updateTodoStatusUseCase(
      todo.id!,
      isFavorite: !todo.isFavorite,
    );
    await refresh();
  }

  /// Todo 삭제
  Future<void> deleteTodo(TodoEntity todo) async {
    if (todo.id == null) return;
    await _deleteTodoUseCase(todo.id!);
    await refresh();
  }
}