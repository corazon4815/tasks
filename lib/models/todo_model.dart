import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}

@freezed
class ToDoModel with _$ToDoModel {
  @JsonSerializable(explicitToJson: true)
  const factory ToDoModel({
    String? id,
    
    required String title,
    @Default(false) bool isDone,
    @Default(false) bool isFavorite,
    
    String? description,
    
    @TimestampConverter()
    required DateTime createdAt,
  }) = _ToDoModel;

  factory ToDoModel.fromJson(Map<String, dynamic> json) => _$ToDoModelFromJson(json);

  factory ToDoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) throw Exception('Document data was null.');
    
    return ToDoModel.fromJson(data).copyWith(
      id: doc.id, 
    );
  }
}

extension ToDoModelX on ToDoModel {
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> json = toJson();
    json.remove('id');
    return json;
  }
}