import 'package:scoped_log_me/models/exerciseSet.dart';

class Exercise {
  String name;
  bool isCheck;
  List<ExerciseSet> exerciseSets;
  List<String> notes;
  Exercise prevExercise = null;
  Exercise head = null;

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

  newNode() {
    Exercise newEx = new Exercise(name: this.name);
    newEx.prevExercise = this;
    this.head = newEx;
    return newEx;
  }

  getPrevExercise() {
    return this.prevExercise;
  }

  bool removePrevExercise() {
    bool success = true;

    (this.prevExercise != null) || (this.prevExercise.getPrevExercise() != null)
        ? this.prevExercise.getPrevExercise()
        : success = false;

    return success;
  }
}
