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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFe0e0e0),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal:16),
            child: Row(
              children: [
                IconButton(
                  onPressed: onToggleDone,
                  icon: Icon(
                    todo.isDone ? Icons.check_circle : Icons.circle_outlined,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    todo.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                  ),
                ),

                const SizedBox(width: 12),

                // Favorite 토글 아이콘
                IconButton(
                  onPressed: onToggleFavorite,
                  icon: Icon(
                    todo.isFavorite ? Icons.star : Icons.star_border,
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
