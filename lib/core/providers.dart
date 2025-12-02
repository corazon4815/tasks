import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/todo_remote_datasource.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/repositories/todo_repository.dart';
import '../domain/usecases/add_todo_usecase.dart';
import '../domain/usecases/delete_todo_usecase.dart';
import '../domain/usecases/get_todos_usecase.dart';
import '../domain/usecases/update_todo_status_usecase.dart';

/// Clean Architecture Dependency Injection
/// 
/// 모든 Provider를 한 곳에서 관리
/// 의존성 방향: Presentation → Domain ← Data

// ============================================================================
// Data Layer
// ============================================================================

/// Firestore 인스턴스
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Remote DataSource
final todoRemoteDataSourceProvider = Provider<TodoRemoteDataSource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return TodoRemoteDataSource(firestore);
});

/// Repository (인터페이스 구현체)
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dataSource = ref.watch(todoRemoteDataSourceProvider);
  return TodoRepositoryImpl(dataSource);
});

// ============================================================================
// Domain Layer - UseCases
// ============================================================================

/// Get Todos UseCase
final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodosUseCase(repository);
});

/// Add Todo UseCase
final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return AddTodoUseCase(repository);
});

/// Update Todo Status UseCase
final updateTodoStatusUseCaseProvider = Provider<UpdateTodoStatusUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return UpdateTodoStatusUseCase(repository);
});

/// Delete Todo UseCase
final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return DeleteTodoUseCase(repository);
});
