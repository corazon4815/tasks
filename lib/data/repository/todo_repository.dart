// lib/data/repository/todo_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/models/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToDoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'todos';

  CollectionReference<Map<String, dynamic>> get _collection => 
      _firestore.collection(_collectionPath);

  Future<void> addTodo(ToDoModel todo) async {
    await _collection.add(todo.toFirestore());
  }
  
  Stream<List<ToDoModel>> getTodos() {
    return _collection
        .orderBy('createdAt', descending: true) // 최신순 정렬
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ToDoModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> updateTodoStatus(String id, {bool? isDone, bool? isFavorite}) async {
    if (id.isEmpty) return;
    
    final updateData = <String, dynamic>{};
    if (isDone != null) updateData['isDone'] = isDone;
    if (isFavorite != null) updateData['isFavorite'] = isFavorite;

    if (updateData.isNotEmpty) {
      await _collection.doc(id).update(updateData);
    }
  }

  Future<void> deleteTodo(String id) async {
    if (id.isEmpty) return;
    await _collection.doc(id).delete();
  }
}

final todoRepositoryProvider = Provider((ref) => ToDoRepository());