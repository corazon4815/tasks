import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//freezed 역할 : 불변성(copyWith), operator ==, hashCode
part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

/**
 * MVVM의 Model
 * - 데이터 구조 정의
 * - 데이터 자체의 형태와 타입 규정
 **/
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

//Flutter 앱의 ToDoModel 객체를 Firestore 데이터베이스가 이해할 수 있는 형태의 Map으로 변환
extension ToDoModelX on ToDoModel {
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> json = toJson();
    json.remove('id');
    return json;
  }
}