import 'package:scoped_log_me/models/body_part.dart';
import 'package:scoped_log_me/models/category.dart';
import 'package:scoped_log_me/models/exerciseSet.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Exercise {
  int id;
  String name;
  bool isCheck;
  List<ExerciseSet> exerciseSets;
  List<String> notes;
  Category category;
  BodyPart bodyPart;

  Exercise(
      {this.id,
      this.name,
      this.isCheck = false,
      this.exerciseSets,
      this.category,
      this.bodyPart,
      this.notes});

  Exercise.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isCheck = json['isCheck'];
    if (json['exerciseSets'] != null) {
      exerciseSets = new List<ExerciseSet>();
      json['exerciseSets'].forEach((v) {
        exerciseSets.add(new ExerciseSet.fromJson(v));
      });
    }
  }

  // Convert an Exercise object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['category'] = EnumToString.parse(category);
    map['bodyPart'] = EnumToString.parse(bodyPart);
    return map;
  }

  // Extract an Exercise object from a Map object
  Exercise.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.category = EnumToString.fromString(Category.values, map['category']);
    this.bodyPart = EnumToString.fromString(BodyPart.values, map['bodyPart']);
  }
}
