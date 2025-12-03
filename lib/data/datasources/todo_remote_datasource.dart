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

  /// Todo 목록을 페이지네이션으로 가져옴
  /// 
  /// - createdAt 기준 내림차순(최신 순)
  /// - [startAfter] 가 있으면, 그 DateTime 보다 과거 데이터부터 조회
  /// - [limit] 개수만큼만 가져옴
  Future<List<TodoDto>> getTodos({
    DateTime? startAfter,
    int limit = 15,
  }) async {
    Query<Map<String, dynamic>> query = _collection
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      // startAfter 보다 이전 데이터만 가져오도록
      query = query.where(
        'createdAt',
        isLessThan: Timestamp.fromDate(startAfter),
      );
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => TodoDto.fromFirestore(doc))
        .toList();
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
