import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/todo_model.dart';
import '/widgets/no_todo.dart';
import '/widgets/todo_view.dart';
import '/widgets/add_todo_sheet.dart';
import 'todo_detail_page.dart';
import '/core/theme_action.dart';

import '/presentation/viewmodel/todo_viewmodel.dart';

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
    final result = await showModalBottomSheet<ToDoModel?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddToDoSheet(),
    );

    if (result == null) {
      _showToast(context, '할 일을 입력해주세요');
      return;
    }

    await ref.read(todoViewModelProvider.notifier).addTodo(result);
  }

  Future<void> _openDetail(BuildContext context, ToDoModel todo) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ToDoDetailPage(todo: todo),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    
    final todosAsync = ref.watch(todoViewModelProvider);

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
            onPressed: () => ThemeAction.of(context)?.toggleThemeMode?.call(),
          ),
        ],
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (todos) {
          if (todos.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
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
                            onAddPressed: () => _openAddSheet(context, ref), // ref 전달
                            cardColor: theme.cardColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final t = todos[index];
              return ToDoView(
                todo: t,
                onToggleDone: () => ref.read(todoViewModelProvider.notifier).toggleDone(t),
                onToggleFavorite: () => ref.read(todoViewModelProvider.notifier).toggleFavorite(t),
                onTap: () => _openDetail(context, t),
                onDelete: () => ref.read(todoViewModelProvider.notifier).deleteTodo(t), 
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddSheet(context, ref),
        child: const Icon(Icons.add, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}