import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/domain/entities/todo_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/viewmodel/todo_viewmodel.dart';

/**
 * Clean Architecture - View
 * - 화면 출력, 사용자 입력 받기
 * - Riverpod을 구독하여 데이터의 최신 상태를 반영
 **/
class ToDoDetailPage extends ConsumerWidget {
  final TodoEntity todo;
  const ToDoDetailPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    const colorSeed = Color(0xFF6750A4);
    final base = Theme.of(context);
    
    /**
     * [데이터 구독] ViewModel의 스트림을 구독하여 현재 ToDo의 최신 상태를 추적
     * 목록에서 넘어온 todo가 아닌 DB의 최신 데이터를 currentTodo로 사용
     */
    final currentTodoAsync = ref.watch(todoViewModelProvider).when(
      loading: () => todo,
      error: (err, stack) => todo,
      data: (todos) {
        // ID를 기준으로 데이터 반환
        return todos.firstWhere(
          (t) => t.id == todo.id,
          orElse: () => todo,
        );
      },
    );
    
    // UI 렌더링을 위해 최신 데이터를 사용
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
              // 이전 화면으로 돌아가기
              onPressed: () => context.pop(),
            ),
            actions: [
              // 즐겨찾기 상태 토글
              IconButton(
                onPressed: () => ref.read(todoViewModelProvider.notifier).toggleFavorite(currentTodo),
                icon: Icon(
                  currentTodo.isFavorite ? Icons.star : Icons.star_border,
                ),
                color: currentTodo.isFavorite ? scheme.secondary : scheme.onSurface,
                tooltip: '즐겨찾기',
              ),
              // 완료/미완료 상태 토글
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
                      child: Hero(
                        tag: currentTodo.id ?? currentTodo.title, // 리스트와 같은 태그
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            currentTodo.title,
                            style: base.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration:
                                  currentTodo.isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
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