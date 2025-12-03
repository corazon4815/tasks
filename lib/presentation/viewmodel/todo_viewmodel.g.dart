// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoViewModelHash() => r'e121c6e32886943e7335b6c5594c7f8eaaafc84a';

/// Clean Architecture - ViewModel
///
/// - Domain Layer의 UseCase만 사용
/// - Repository나 DataSource에 직접 접근하지 않음
/// - 페이지네이션 + Pull-to-Refresh + Infinite Scroll
///
/// Copied from [TodoViewModel].
@ProviderFor(TodoViewModel)
final todoViewModelProvider =
    AutoDisposeAsyncNotifierProvider<TodoViewModel, List<TodoEntity>>.internal(
  TodoViewModel.new,
  name: r'todoViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoViewModel = AutoDisposeAsyncNotifier<List<TodoEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
