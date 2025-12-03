import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_dto.dart';

/// Data Layer - Repository Implementation
/// 
/// Domain의 TodoRepository 인터페이스를 구현
/// DataSource를 사용하여 데이터를 가져오고 DTO ↔ Entity 변환

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource _remoteDataSource;

  TodoRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<List<TodoEntity>> getTodos({
    DateTime? startAfter,
    int limit = 15,
  }) async {
    final dtoList = await _remoteDataSource.getTodos(
      startAfter: startAfter,
      limit: limit,
    );

    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> addTodo(TodoEntity todo) async {
    // Entity를 DTO로 변환하여 DataSource에 전달
    final dto = TodoDto.fromEntity(todo);
    await _remoteDataSource.addTodo(dto);
  }

  @override
  Future<void> updateTodoStatus(
    String id, {
    bool? isDone,
    bool? isFavorite,
  }) async {
    await _remoteDataSource.updateTodoStatus(
      id,
      isDone: isDone,
      isFavorite: isFavorite,
    );
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _remoteDataSource.deleteTodo(id);
  }
}
