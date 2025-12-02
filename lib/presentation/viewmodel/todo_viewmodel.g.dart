// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoViewModelHash() => r'5f02e534b1e410c0c44c8f1cde6ef0c397ed41af';
/**
 * Clean Architecture - ViewModel
 * 
 * - Domain Layer의 UseCase만 사용
 * - Repository나 DataSource에 직접 접근하지 않음
 * - 비즈니스 로직은 UseCase에 위임
 */
///
/// Copied from [TodoViewModel].
@ProviderFor(TodoViewModel)
final todoViewModelProvider =
    AutoDisposeStreamNotifierProvider<TodoViewModel, List<TodoEntity>>.internal(
  TodoViewModel.new,
  name: r'todoViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoViewModel = AutoDisposeStreamNotifier<List<TodoEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
