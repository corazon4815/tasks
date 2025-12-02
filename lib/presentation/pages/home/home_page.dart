import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/domain/entities/todo_entity.dart';
import 'widgets/no_todo.dart';
import 'widgets/todo_view.dart';
import 'widgets/add_todo_sheet.dart';
import '../todo_detail/todo_detail_page.dart';
import '/core/theme_provider.dart';

import '/presentation/viewmodel/todo_viewmodel.dart';

/**
 * Clean Architecture - View
 * - 화면 출력, 사용자 입력 받기
 * - Domain의 Entity 사용
 **/
class HomePage extends ConsumerWidget {
  final String studentName;

  const HomePage({super.key, required this.studentName});
  
  String get _appTitle => "$studentName's Tasks";

  void _showToast(BuildContext context, String message) {
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

  Future<void> _openAddSheet(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<dynamic>( 
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddToDoSheet(),
    );

    if (!context.mounted) return;

    if (result is TodoEntity) {
      /**
       * ref.read (일회성 명령) :
       * UI를 리빌드하지 않고 ViewModel의 함수만 호출
       * Riverpod에서 상태를 변경하는 모든 명령은 ref.read로 시작해야 함
       * 버튼클릭이나 로직함수 내부에서 사용
       */
      await ref.read(todoViewModelProvider.notifier).addTodo(result);
      
    } else if (result == false) {
      _showToast(context, '할 일을 입력해주세요');
    }
    //result == null 일 경우: 사용자가 모달을 닫거나 스와이프했을 때 동작 없음
  }

  Future<void> _openDetail(BuildContext context, TodoEntity todo) async {
    context.push('/detail', extra: todo);
  }

  /**
   * Riverpod : setState()대신 WidgetRef ref
   * 
   */
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    /**
     * ref.watch (데이터 구독) :
     * todoViewModelProvider의 상태(ToDo 목록)가 Firestore에서 변경될 때마다
     * ref.watch를 쓰는 HomePage 위젯 전체가 자동으로 리빌드됨(실시간으로 지켜봄)
     * build 메서드 내부에서 사용
     */
    final todosAsync = ref.watch(todoViewModelProvider);

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
            onPressed: () => ref.read(themeModeNotifierProvider.notifier).toggle(),
          ),
        ],
      ),
      /**
       * AsyncValue.when (비동기 데이터 처리) :
       * when 메서드로 
       * 1.로딩 중에는 CircularProgressIndicator를
       * 2.에러 발생 시에는 에러 메시지를 
       * 3.데이터가 도착하면 목록을 보여주도록 분기 처리 가능
       */
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (todos) {
          if (todos.isEmpty) {
            return LayoutBuilder(
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
                            //할 일 추가 시트 열기
                            onAddPressed: () => _openAddSheet(context, ref), // ref 전달
                            cardColor: theme.cardColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final t = todos[index];
              return ToDoView(
                todo: t,
                //완료 상태 토글
                onToggleDone: () => ref.read(todoViewModelProvider.notifier).toggleDone(t),
                //즐겨찾기 상태 토글
                onToggleFavorite: () => ref.read(todoViewModelProvider.notifier).toggleFavorite(t),
                //상세 보기 페이지 열기
                onTap: () => _openDetail(context, t),
                //ToDo 삭제
                onDelete: () => ref.read(todoViewModelProvider.notifier).deleteTodo(t), 
              );
            },
          );
        },
      ),
      //할 일 추가 시트 열기
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddSheet(context, ref),
        child: const Icon(Icons.add, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}