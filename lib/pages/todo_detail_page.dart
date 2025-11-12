import 'package:flutter/material.dart';
import '/models/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/viewmodel/todo_viewmodel.dart';

class ToDoDetailPage extends ConsumerWidget {
  final ToDoModel todo;
  const ToDoDetailPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    const colorSeed = Color(0xFF6750A4);
    final base = Theme.of(context);
    
    final currentTodoAsync = ref.watch(todoViewModelProvider).when(
      loading: () => todo,
      error: (err, stack) => todo,
      data: (todos) {
        return todos.firstWhere(
          (t) => t.id == todo.id,
          orElse: () => todo,
        );
      },
    );
    
    final currentTodo = currentTodoAsync; 
    
    final scheme = ColorScheme.fromSeed(
      seedColor: colorSeed,
      brightness: base.brightness,
    );

    final localTheme = base.copyWith(
    );

    return Theme(
      data: localTheme,
      child: PopScope(
        canPop: true,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                onPressed: () => ref.read(todoViewModelProvider.notifier).toggleFavorite(currentTodo),
                icon: Icon(
                  currentTodo.isFavorite ? Icons.star : Icons.star_border,
                ),
                color: currentTodo.isFavorite ? scheme.secondary : scheme.onSurface,
                tooltip: '즐겨찾기',
              ),
              IconButton(
                onPressed: () => ref.read(todoViewModelProvider.notifier).toggleDone(currentTodo),
                icon: Icon(
                  currentTodo.isDone ? Icons.check_circle : Icons.circle_outlined,
                ),
                color: currentTodo.isDone ? scheme.primary : scheme.onSurface,
                tooltip: currentTodo.isDone ? '미완료로 표시' : '완료로 표시',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentTodo.title,
                        style: base.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration:
                              currentTodo.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if ((currentTodo.description ?? '').isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.short_text_rounded, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          currentTodo.description!,
                          style: base.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    '세부 내용이 없습니다.',
                    style: base.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}