import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/todo_detail/todo_detail_page.dart';
import '../domain/entities/todo_entity.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(studentName: '수진'),
      ),
      GoRoute(
        path: '/detail',
        name: 'detail',
        builder: (context, state) {
          final todo = state.extra as TodoEntity;
          return ToDoDetailPage(todo: todo);
        },
      ),
    ],
  );
}
