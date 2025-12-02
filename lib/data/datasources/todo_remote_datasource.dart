import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_dto.dart';

/// Data Layer - Remote DataSource
/// 
/// Firestore와의 실제 통신을 담당
/// DTO를 사용하여 데이터 전송

class TodoRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'todos';

  TodoRemoteDataSource(this._firestore);

  /// 'todos' 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionPath);

  /// Todo 목록을 실시간으로 가져오는 Stream (DTO 반환)
  Stream<List<TodoDto>> getTodos() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TodoDto.fromFirestore(doc))
          .toList();
    });
  }

  /// 새로운 Todo 추가
  Future<void> addTodo(TodoDto dto) async {
    await _collection.add(dto.toFirestore());
  }

  /// Todo 상태 업데이트
  Future<void> updateTodoStatus(
    String id, {
    bool? isDone,
    bool? isFavorite,
  }) async {
    if (id.isEmpty) return;

    final updateData = <String, dynamic>{};
    if (isDone != null) updateData['isDone'] = isDone;
    if (isFavorite != null) updateData['isFavorite'] = isFavorite;

    if (updateData.isNotEmpty) {
      await _collection.doc(id).update(updateData);
    }
  }

  /// Todo 삭제
  Future<void> deleteTodo(String id) async {
    if (id.isEmpty) return;
    await _collection.doc(id).delete();
  }
}
