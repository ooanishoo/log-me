import 'package:scoped_log_me/models/exerciseSet.dart';

class Exercise {
  String name;
  bool isCheck;
  List<ExerciseSet> exerciseSets;
  List<String> notes = [];

  Exercise({this.name, this.isCheck = false, this.exerciseSets, this.notes});

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
}
