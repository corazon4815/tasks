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
    const colorSeed = Color(0xFF6750A4);
    final base = Theme.of(context);
    final scheme = ColorScheme.fromSeed(
      seedColor: colorSeed,
      brightness: base.brightness,
    );

    final localTheme = base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      iconTheme: base.iconTheme.copyWith(color: scheme.onSurfaceVariant),
      cardTheme: base.cardTheme.copyWith(
        color: scheme.surfaceContainerHighest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    return Theme(
      data: localTheme,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.of(context).pop<ToDoEntity>(_current);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop<ToDoEntity>(_current),
            ),
            actions: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _current.isFavorite ? Icons.star : Icons.star_border,
                ),
                color: _current.isFavorite ? scheme.secondary : scheme.onSurface,
                tooltip: '즐겨찾기',
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
                        style: base.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration:
                              _current.isDone ? TextDecoration.lineThrough : null,
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
