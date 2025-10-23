import 'package:flutter/material.dart';
import '/models/todo_entity.dart';
import '/widgets/no_todo.dart';
import '/widgets/todo_view.dart';
import '/widgets/add_todo_sheet.dart';
import 'todo_detail_page.dart';
import '/core/theme_action.dart';

class HomePage extends StatefulWidget {
  final String studentName;

  const HomePage({super.key, required this.studentName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ToDoEntity> _todos = [];
  String get _appTitle => "${widget.studentName}'s Tasks";

  // 스낵바
  void _showToast(String message) {
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

  Future<void> _openAddSheet() async {
    final result = await showModalBottomSheet<ToDoEntity?>(
      context: context,
      isScrollControlled: true,
      // useRootNavigator: true, // 필요하면 루트 스캐폴드 기준으로 띄우고 싶을 때 활성화
      builder: (context) => const AddToDoSheet(),
    );

    if (!mounted) return;

    // ✅ 시트가 null로 종료되면(빈 제목 등) 여기서 스낵바 표시
    if (result == null) {
      _showToast('할 일을 입력해주세요');
      return;
    }

    setState(() => _todos.insert(0, result));
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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

      body: _todos.isEmpty
          ? LayoutBuilder(
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
                            onAddPressed: _openAddSheet,
                            // ❌ 하드코딩: const Color(0xFFe0e0e0)
                            // ✅ 카드/표면 계열 색
                            cardColor: theme.cardColor, // 또는 scheme.surfaceVariant
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
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
        onPressed: _openAddSheet,
        child: const Icon(Icons.add, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
