import 'package:flutter/material.dart';
import 'package:tasks/core/theme_action.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:tasks/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp();
    //options: DefaultFirebaseOptions.currentPlatform,
  //);
  runApp(const TasksApp());
}

class TasksApp extends StatefulWidget {
  const TasksApp({super.key});

  @override
  State<TasksApp> createState() => _TasksAppState();
}

class _TasksAppState extends State<TasksApp> {
  ThemeMode _themeMode = ThemeMode.light;
  void _toggleThemeMode() => setState(() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  });

  @override
  Widget build(BuildContext context) {
    const colorSeed = Color(0xFF6750A4);

    ThemeData buildTheme(Brightness brightness) {
      final scheme = ColorScheme.fromSeed(
        seedColor: colorSeed,
        brightness: brightness,
      );
      return ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surface,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        cardColor: scheme.surfaceVariant,
        cardTheme: CardThemeData(
          color: scheme.surfaceVariant,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        listTileTheme: ListTileThemeData(iconColor: scheme.onSurfaceVariant),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: const CircleBorder(),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: scheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'tasks',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: ThemeAction(
        toggleThemeMode: _toggleThemeMode,
        child: const HomePage(studentName: '수진'),
      ),
    );
  }
}

