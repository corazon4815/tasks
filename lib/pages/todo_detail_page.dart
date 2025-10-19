import 'package:flutter/material.dart';
import '/models/todo_entity.dart';

class ToDoDetailPage extends StatefulWidget {
  final ToDoEntity todo;

  const ToDoDetailPage({super.key, required this.todo});

  @override
  State<ToDoDetailPage> createState() => _ToDoDetailPageState();
}

class _ToDoDetailPageState extends State<ToDoDetailPage> {
  late ToDoEntity _current;

  @override
  void initState() {
    super.initState();
    _current = widget.todo;
  }

  void _toggleFavorite() {
    setState(() {
      _current = _current.copyWith(isFavorite: !_current.isFavorite);
    });
  }

  void _toggleDone() {
    setState(() {
      _current = _current.copyWith(isDone: !_current.isDone);
    });
  }

  @override
  Widget build(BuildContext context) {
 
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop<ToDoEntity>(_current); // 결과와 함께 직접 pop
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFB9B9B9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFE0E0E0),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop<ToDoEntity>(_current),
          ),
          actions: [
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(_current.isFavorite ? Icons.star : Icons.star_border),
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
                      _current.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: _current.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if ((_current.description ?? '').isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.short_text_rounded, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _current.description!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  '세부 내용이 없습니다.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
            ],
          ),
        ),
      ),
    );

  }
}
