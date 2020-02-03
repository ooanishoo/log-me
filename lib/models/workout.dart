import 'package:scoped_log_me/models/exercise.dart';

class Workout {
  String name;
  DateTime date;
  bool isActive;
  List<Exercise> exercises = [];

  List get getExercise => exercises;
  set setExercise(List<Exercise> value) => this.exercises = value;

  Workout({
    this.name,
    this.exercises,
    this.isActive = true,
    this.date,
  });

  Workout.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['exercises'] != null) {
      exercises = new List<Exercise>();
      json['exercises'].forEach((v) {
        exercises.add(new Exercise.fromJson(v));
      });
    }
  }
}
