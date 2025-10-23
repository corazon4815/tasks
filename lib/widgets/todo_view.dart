import 'package:flutter/material.dart';
import '/models/todo_entity.dart';

class ToDoView extends StatelessWidget {
  final ToDoEntity todo;
  final VoidCallback onToggleDone;      // 외부에서 상태 변경 함수 주입
  final VoidCallback onToggleFavorite;  // 외부에서 상태 변경 함수 주입
  final VoidCallback onTap;             // 상세 보기 등 탭 동작

  const ToDoView({
    super.key,
    required this.todo,
    required this.onToggleDone,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final tileBg = theme.cardColor;

    final doneColor = todo.isDone ? scheme.primary : scheme.onSurfaceVariant;
    final favColor  = todo.isFavorite ? scheme.secondary : scheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outlineVariant, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onToggleDone,
                    icon: Icon(
                      todo.isDone ? Icons.check_circle : Icons.circle_outlined,
                    ),
                    color: doneColor,
                    tooltip: todo.isDone ? '미완료로 표시' : '완료로 표시',
                  ),

                  const SizedBox(width: 12),

                  // 제목
                  Expanded(
                    child: Text(
                      todo.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scheme.onSurface,
                        decoration:
                            todo.isDone ? TextDecoration.lineThrough : null,
                        decorationThickness: 2,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 즐겨찾기 토글
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(todo.isFavorite ? Icons.star : Icons.star_border),
                    color: favColor,
                    tooltip: todo.isFavorite ? '즐겨찾기 해제' : '즐겨찾기',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
