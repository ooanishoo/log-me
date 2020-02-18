import 'package:scoped_log_me/models/enums/body_part.dart';
import 'package:scoped_log_me/models/enums/exercise_category.dart';
import 'package:scoped_log_me/models/exerciseSet.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Exercise{
  int id;
  String name;
  bool isCheck;
  List<ExerciseSet> exerciseSets=[];
  List<String> notes=[];
  ExerciseCategory exerciseCategory;
  BodyPart bodyPart;

  Exercise(
      {this.id,
      this.name,
      this.isCheck = false,
      this.exerciseSets,
      this.exerciseCategory,
      this.bodyPart,
      this.notes});

  // Convert an Exercise object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.hashCode;
    map['name'] = this.name;
    map['exerciseCategory'] = EnumToString.parse(this.exerciseCategory);
    map['bodyPart'] = EnumToString.parse(this.bodyPart);
    if(this.exerciseSets != null){
      map['exerciseSets'] = this.exerciseSets.map((exSet) => exSet.toMap()).toList();
    }
    return map;
  }

  // Extract an Exercise object from a Map object
  Exercise.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];

    if (map['exerciseSets'] != null) {
      exerciseSets = new List<ExerciseSet>();
      map['exerciseSets'].forEach((v) {
        exerciseSets.add(new ExerciseSet.fromMap(v));
      });
    }
    if (map['exerciseCategory'] != null) {
      this.exerciseCategory = EnumToString.fromString(ExerciseCategory.values, map['exerciseCategory']);
    }
    if (map['bodyPart'] != null) {
      this.bodyPart = EnumToString.fromString(BodyPart.values, map['bodyPart']);
    }
  }
}
