import 'package:scoped_log_me/models/exercise.dart';

class Workout {
  String name;
  DateTime date;
  bool isActive;
  List<Exercise> exercise;

  List get getExercise => exercise;
  set setExercise(List<Exercise> value) => this.exercise = value;

  Workout({
    this.name,
    this.exercise,
    this.isActive = true,
    this.date,
  });

  Workout.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['exercise'] != null) {
      exercise = new List<Exercise>();
      json['exercise'].forEach((v) {
        exercise.add(new Exercise.fromJson(v));
      });
    }
  }
}
