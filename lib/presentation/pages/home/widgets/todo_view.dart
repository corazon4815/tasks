import 'package:flutter/material.dart';
import '/models/todo_model.dart';

class ToDoView extends StatelessWidget {
  final ToDoModel todo;
  // [콜백] 완료 상태 토글 요청
  final VoidCallback onToggleDone;
  // [콜백] 즐겨찾기 상태 토글 요청
  final VoidCallback onToggleFavorite;
  // [콜백] 상세 페이지 열기 요청
  final VoidCallback onTap;
  // [콜백] 항목 삭제 요청
  final VoidCallback onDelete;

  const ToDoView({
    super.key,
    required this.todo,
    required this.onToggleDone,
    required this.onToggleFavorite,
    required this.onTap,
    required this.onDelete,
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
          onTap: onTap, // 항목 탭 시 상세 보기 요청
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
                  // 항목 삭제 버튼
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    color: scheme.onSurfaceVariant,
                    tooltip: '삭제',
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
