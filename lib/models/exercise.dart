import 'package:scoped_log_me/models/exerciseSet.dart';

class Exercise {
  String name;
  bool isCheck;
  List<ExerciseSet> exerciseSet;
  List<String> notes = [];

  Exercise({this.name, this.isCheck = false, this.exerciseSet, this.notes});

  Exercise.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isCheck = json['isCheck'];
    if (json['exerciseSet'] != null) {
      exerciseSet = new List<ExerciseSet>();
      json['exerciseSet'].forEach((v) {
        exerciseSet.add(new ExerciseSet.fromJson(v));
      });
    }
  }
}
