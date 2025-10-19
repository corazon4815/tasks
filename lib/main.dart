import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const TasksApp());
}

class TasksApp extends StatefulWidget {
  const TasksApp({super.key});

  @override
  State<TasksApp> createState() => _TasksAppState();
}

class _TasksAppState extends State<TasksApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorSeed = const Color(0xFF6750A4);

    return MaterialApp(
      title: 'tasks',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: colorSeed),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: colorSeed, brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: _ThemeAction(
        toggleThemeMode: _toggleThemeMode,
        child: const HomePage(studentName: '수진'),
      ),
    );
  }
}

/// HomePage에서 테마 토글을 호출하기 위해 import
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
