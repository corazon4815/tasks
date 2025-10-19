import 'package:flutter/material.dart';
import '/models/todo_entity.dart';
import '/widgets/no_todo.dart';
import '/widgets/todo_view.dart';
import '/widgets/add_todo_sheet.dart';
import 'todo_detail_page.dart';

class HomePage extends StatefulWidget {
  final String studentName;

  const HomePage({super.key, required this.studentName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ToDoEntity> _todos = [];

  String get _appTitle => "${widget.studentName}`s Tasks";

  Future<void> _openAddSheet() async {
    final result = await showModalBottomSheet<ToDoEntity>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: const Color(0xFFF6F6F6), // ← #F6F6F6
      builder: (context) => const AddToDoSheet(),
    );

    if (result != null) {
      setState(() {
        _todos.insert(0, result);
      });
    }
  }

  Future<void> _openDetail(int index) async {
    final original = _todos[index];
    final updated = await Navigator.of(context).push<ToDoEntity>(
      MaterialPageRoute(
        builder: (_) => ToDoDetailPage(todo: original),
      ),
    );

    if (updated != null) {
      setState(() {
        _todos[index] = updated;
      });
    }
  }

  void _toggleDone(int index) {
    final t = _todos[index];
    setState(() {
      _todos[index] = t.copyWith(isDone: !t.isDone);
    });
  }

  void _toggleFavorite(int index) {
    final t = _todos[index];
    setState(() {
      _todos[index] = t.copyWith(isFavorite: !t.isFavorite);
    });
  }

  @override
Widget build(BuildContext context) {
  const bgGray = Color(0xFFBDBDBD);
  const fabOrange = Color(0xFFE64A19);
  const appBarGray = Color(0xFFE0E0E0);

  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: bgGray,
    appBar: AppBar(
      backgroundColor: appBarGray,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "수진`s Tasks",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          tooltip: '테마 전환',
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode,
          ),
          onPressed: () => _ThemeAction.of(context)?.toggleThemeMode?.call(),
        ),
      ],
    ),

   body: _todos.isEmpty
    ? LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                widthFactor: 1.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: NoToDo(
                      appBarTitle: _appTitle,
                      onAddPressed: _openAddSheet,
                      cardColor: const Color(0xFFe0e0e0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      )
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              final t = _todos[index];
              return ToDoView(
                todo: t,
                onToggleDone: () => _toggleDone(index),
                onToggleFavorite: () => _toggleFavorite(index),
                onTap: () => _openDetail(index),
              );
            },
          ),

    floatingActionButton: FloatingActionButton(
      shape: const CircleBorder(), 
      backgroundColor: fabOrange,
      foregroundColor: Colors.white,
      onPressed: _openAddSheet,
      child: const Icon(Icons.add, size: 24),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}

}

/// 상위(MaterialApp)에서 테마 토글 콜백을 전달하기 위한 간단한 InheritedWidget
class _ThemeAction extends InheritedWidget {
  final VoidCallback? toggleThemeMode;

  const _ThemeAction({
    required super.child,
    this.toggleThemeMode,
  });

  static _ThemeAction? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ThemeAction>();
  }

  @override
  bool updateShouldNotify(_ThemeAction oldWidget) =>
      toggleThemeMode != oldWidget.toggleThemeMode;
}
