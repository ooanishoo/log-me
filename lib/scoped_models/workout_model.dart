import 'package:scoped_log_me/models/workout.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/models/exerciseSet.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math';

class WorkoutModel extends Model {
  Workout currentWorkout;
  List<Exercise> _selectedExercises = [];
  List<Workout> _workouts = [];

  List<Exercise> get selectedExercises => this._selectedExercises;
  List<Workout> get workouts => this._workouts;

  void startWorkout() {
    // set new workout object as currentWorkout
    String name = Random().nextInt(100).toString();
    currentWorkout = new Workout(
      name: 'Workout $name',
      date: new DateTime.now(),
    );
    print('Workout name is ::' + name);
    notifyListeners();
  }

  void finishWorkout() {
    workouts.add(currentWorkout);
  }

  void cancelWorkout() {
    print('cancelling workout');
    _selectedExercises.clear();
    notifyListeners();
  }

  void addWorkout(Workout value) {
    workouts.add(value);
    print(workouts.length.toString());
    notifyListeners();
  }

  void removeWorkout(Workout value) {
    workouts.remove(value);
    notifyListeners();
  }

  void addExercises(List<Exercise> value) {
    initializeFirstSet(value);
    selectedExercises.addAll(value);
    currentWorkout.exercise = selectedExercises;
    print('coming from workout model' + selectedExercises.length.toString());
    notifyListeners();
  }

  void removeExercise(Exercise value) {
    if (currentWorkout.exercise.contains(value))
      currentWorkout.exercise.remove(value);
    notifyListeners();
  }

  void selectExercise(Exercise value) {
    selectedExercises.add(value);
    notifyListeners();
  }

  void initializeFirstSet(List<Exercise> exercises) {
    exercises
        .forEach((exercise) => exercise.exerciseSet = [ExerciseSet(index: 1)]);
  }

  void unselectExercise(Exercise value) {
    selectedExercises.remove(value);
    print("Selected Exercises is ::" + selectedExercises.length.toString());
    notifyListeners();
  }

  void addSet(Exercise exercise) {
    if (exercise.exerciseSet != null) {
      exercise.exerciseSet
          .add(ExerciseSet(index: exercise.exerciseSet.length + 1));
      notifyListeners();
    }
  }

  void removeSet(Exercise exercise, ExerciseSet set) {
    if (exercise.exerciseSet.contains(set)) {
      exercise.exerciseSet.remove(set);
      notifyListeners();
    }
  }

  void updateSet(ExerciseSet set, double value) {
    print('value is $value');
    set.weight = value;
    notifyListeners();
  }

  void updateSetType(ExerciseSet set, ExerciseSetType type) {
    print('from model' + set.type.toString());
    set.type = type;
    notifyListeners();
  }

  void addNoteToExercise(Exercise exercise) {
    //if (exercise.notes.length > 0) {
    exercise.notes.add('Add note $exercise.notes.length+1.toString()');
    notifyListeners();
    //}
  }

  void removeNoteFromExercise(Exercise exercise, String note) {
    if (exercise.notes.length > 0 && exercise.notes.contains(note)) {
      exercise.notes.remove(note);
      notifyListeners();
    }
  }
}
