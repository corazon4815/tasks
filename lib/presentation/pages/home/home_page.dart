import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import '/domain/entities/todo_entity.dart';
import 'widgets/no_todo.dart';
import 'widgets/todo_view.dart';
import 'widgets/add_todo_sheet.dart';
import '/core/theme_provider.dart';

import '/presentation/viewmodel/todo_viewmodel.dart';

/**
 * Clean Architecture - View
 * - 화면 출력, 사용자 입력 받기
 * - Domain의 Entity 사용
 **/
class HomePage extends ConsumerWidget {
  final String studentName;

  const HomePage({super.key, required this.studentName});
  
  String get _appTitle => "$studentName's Tasks";

  void _showToast(BuildContext context, String message) {
    final m = ScaffoldMessenger.of(context);
    final safeBottom = MediaQuery.of(context).padding.bottom;

    m.hideCurrentSnackBar();
    m.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(12, 12, 12, 12 + safeBottom),
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _openAddSheet(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<dynamic>( 
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddToDoSheet(),
    );

    if (!context.mounted) return;

    if (result is TodoEntity) {
      await ref.read(todoViewModelProvider.notifier).addTodo(result);
    } else if (result == false) {
      _showToast(context, '할 일을 입력해주세요');
    }
  }

  Future<void> _openDetail(BuildContext context, TodoEntity todo) async {
    context.push('/detail', extra: todo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final todosAsync = ref.watch(todoViewModelProvider);
    final vm = ref.read(todoViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: '테마 전환',
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => ref.read(themeModeNotifierProvider.notifier).toggle(),
          ),
        ],
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (todos) {
          // ✅ 1) 비어 있을 때 화면 (그대로 유지)
          if (todos.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => vm.refresh(),
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 700),
                            child: NoToDo(
                              appBarTitle: _appTitle,
                              onAddPressed: () => _openAddSheet(context, ref),
                              cardColor: theme.cardColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // ✅ 2) 리스트 있을 때: Pull to Refresh + Infinite Scroll
          final hasMore = vm.hasMore;
          final isLoadingMore = vm.isLoadingMore;

          return RefreshIndicator(
            onRefresh: () => vm.refresh(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // 리스트 맨 아래 근처까지 스크롤되면 loadMore 호출
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 100 &&
                    hasMore &&
                    !isLoadingMore) {
                  vm.loadMore();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: todos.length + (hasMore ? 1 : 0), 
                itemBuilder: (context, index) {
                  // 마지막 한 칸은 "로딩중 인디케이터" 슬롯
                  if (index == todos.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final t = todos[index];
                  return ToDoView(
                    todo: t,
                    onToggleDone: () =>
                        ref.read(todoViewModelProvider.notifier).toggleDone(t),
                    onToggleFavorite: () =>
                        ref.read(todoViewModelProvider.notifier).toggleFavorite(t),
                    onTap: () => _openDetail(context, t),
                    onDelete: () =>
                        ref.read(todoViewModelProvider.notifier).deleteTodo(t),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: TapDebouncer(
        onTap: () => _openAddSheet(context, ref),
        cooldown: const Duration(milliseconds: 800),
        builder: (BuildContext context, TapDebouncerFunc? onTap) {
          return FloatingActionButton(
            onPressed: onTap,
            child: const Icon(Icons.add, size: 24),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}