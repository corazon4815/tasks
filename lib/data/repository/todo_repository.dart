import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/models/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/**
 * [MVVM Repository]
 * - Firestore 데이터베이스와의 통신(CRUD)을 전담
 * - UI나 비즈니스 로직에 관여하지 않고 데이터 요청/응답만 처리
 */
class ToDoRepository {
  // Firestore 인스턴스 (데이터베이스 연결)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'todos';

  // [속성] 'todos' 컬렉션 참조 getter
  CollectionReference<Map<String, dynamic>> get _collection => 
      _firestore.collection(_collectionPath);

  // [기능] C: Create (할 일 추가)
  Future<void> addTodo(ToDoModel todo) async {
    await _collection.add(todo.toFirestore());
  }
  
  // [기능] R: Read (할 일 목록 실시간 스트림)
  Stream<List<ToDoModel>> getTodos() {
    return _collection
        .orderBy('createdAt', descending: true) // 최신순 정렬
        .snapshots()
        .map((snapshot) { // Firestore로부터 실시간 업데이트(Stream)를 받음
      // DocumentSnapshot 리스트를 ToDoModel 리스트로 변환하여 반환  
      return snapshot.docs
          .map((doc) => ToDoModel.fromFirestore(doc))
          .toList();
    });
  }

  // [기능] U: Update (상태 변경 - 완료/즐겨찾기)
  Future<void> updateTodoStatus(String id, {bool? isDone, bool? isFavorite}) async {
    if (id.isEmpty) return;
    
    final updateData = <String, dynamic>{};
    if (isDone != null) updateData['isDone'] = isDone;
    if (isFavorite != null) updateData['isFavorite'] = isFavorite;

    if (updateData.isNotEmpty) {
      // 해당 ID의 문서만 찾아서 필드를 부분적으로 업데이트
      await _collection.doc(id).update(updateData);
    }
  }

  // [기능] D: Delete (할 일 삭제)
  Future<void> deleteTodo(String id) async {
    if (id.isEmpty) return;
    await _collection.doc(id).delete();
  }
}

// [Riverpod Provider]
// ViewModel에서 ToDoRepository 인스턴스를 가져올 수 있도록 정의
final todoRepositoryProvider = Provider((ref) => ToDoRepository());