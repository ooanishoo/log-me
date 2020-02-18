import 'package:scoped_log_me/helper/database.dart';
import 'package:scoped_log_me/models/enums/exerciseSetType.dart';
import 'package:scoped_log_me/models/workout.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/models/exerciseSet.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math';

class WorkoutModel extends Model {
  Workout currentWorkout;
  List<Exercise> selectedExercises = [];
  List<Workout> workouts = [];
  DbHelper dbHelper = DbHelper();

  WorkoutModel();

  void startWorkout() {
    // set new workout object as currentWorkout
    String name = Random().nextInt(100).toString();
    currentWorkout = new Workout(
      name: 'Workout $name',
      date: new DateTime.now(),
      exercises: [],
    );

    dbHelper.insertWorkout(currentWorkout);
    print('Workout name is ::' + name);
    notifyListeners();
  }

  void getAllWorkouts() async {
    // Fetch all the exercises from database
    List<Workout> workoutList = await dbHelper.getAllWorkouts();

    print('size is ************');
    print(workoutList.length.toString());

    // set the list to appModel's exerciseList
    workouts = workoutList;
    notifyListeners();
  }

  Future<void> finishWorkout() async{
    workouts.add(currentWorkout);
    //dbHelper.insertWorkout(currentWorkout);

    dbHelper.updateWorkout(currentWorkout);
  }
  Future<void> saveWorkout() async{
    //workouts.add(currentWorkout);
    //dbHelper.insertWorkout(currentWorkout);

    dbHelper.updateWorkout(currentWorkout);
    //currentWorkout = null;
  }

  void cancelWorkout() {
    print('cancelling workout');
    dbHelper.deleteWorkout(currentWorkout);
    currentWorkout = null;
  }

  void addWorkout(Workout value) {
    workouts.add(value);
    notifyListeners();
  }

  void removeWorkout(Workout value) {
    workouts.remove(value);
    notifyListeners();
  }

  void addExercises(List<Exercise> exercises) {
    exercises.map((ex) {
      return selectedExercises.add(new Exercise()..name = ex.name);
      // return selectedExercises.add(ex.newNode());
    }).toList();

    initializeFirstSet(selectedExercises);
    currentWorkout.exercises.addAll(selectedExercises);
    selectedExercises.clear();
    notifyListeners();
  }

  void removeExercise(Exercise value) {
    if (currentWorkout.exercises.contains(value))
      currentWorkout.exercises.remove(value);
    notifyListeners();
  }

  void initializeFirstSet(List<Exercise> exercises) {
    exercises.forEach(
        (exercise) => exercise.exerciseSets = [new ExerciseSet(index: 1)]);
  }

  void addSet(Exercise exercise) {
    if (exercise.exerciseSets == null) {
      exercise.exerciseSets = new List<ExerciseSet>();
    }
    exercise.exerciseSets.add(
      ExerciseSet(index: exercise.exerciseSets.length + 1)
    );
    notifyListeners();
  }

  void removeSet(Exercise exercise, ExerciseSet set) {
    if (exercise.exerciseSets.contains(set)) {
      exercise.exerciseSets.remove(set);
      notifyListeners();
    }
  }

  void updateWeight(ExerciseSet set, double value) {
    print('value is $value');
    set.weight = value;
    //notifyListeners();
  }

  void updateRep(ExerciseSet set, int value) {
    print('value is $value');
    set.reps = value;
    //notifyListeners();
  }

  void updateSetType(ExerciseSet set, ExerciseSetType type) {
    print('from model' + set.type.toString());
    set.type = type;
    notifyListeners();
  }

  void addNoteToExercise(Exercise exercise) {
    if (exercise.notes == null) {
      exercise.notes = [];
    }
    exercise.notes.add('');
    notifyListeners();
  }

  void removeNoteFromExercise(Exercise exercise, String note) {
    if (exercise.notes.length > 0 && exercise.notes.contains(note)) {
      exercise.notes.remove(note);
      notifyListeners();
    }
  }
}
