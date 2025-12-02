import 'package:flutter/material.dart';
import 'package:tasks/core/app_theme.dart';
import 'package:tasks/core/theme_provider.dart';
import 'package:tasks/core/router_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/**
 * Firestore Stream
 * 1. Firestore : 데이터베이스
 * 2. Repository : Firestore와 직접 통신하며 Stream을 열어둠
 * 3. ViewModel : Repository의 Stream을 받아서 Riverpod Provider에 넣어줌
 * 4. View (HomePage) : ref.watch를 통해 이 Provider를 구독
 * DB → Repository → ViewModel → View
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: TasksApp(),
    ),
  );
}

class TasksApp extends ConsumerWidget {
  const TasksApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'tasks',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}

