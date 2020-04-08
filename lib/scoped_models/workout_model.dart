import 'package:intl/intl.dart';
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

  WorkoutModel() {
    this.getAllWorkouts();
  }

  // Find current active workout from the workout list
  void getCurrentWorkout() {
    currentWorkout = null;
    Workout workout = workouts.firstWhere((workout) => workout.isActive == true,
        orElse: () => null);
    if (workout != null) {
      this.currentWorkout = workout;
      notifyListeners();
    }
  }

  void startWorkout() {
    // Initalize new currentWorkout object
    String name = Random().nextInt(100).toString();
    currentWorkout = new Workout(
      id: Random().nextInt(1000000),
      name: 'Workout $name',
      date: new DateTime.now(),
      isActive: true,
      exercises: [],
    );

    // Add the workout to list
    workouts.add(currentWorkout);

    // Insert workout in database
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

  Future<void> finishWorkout() async {
    // Set active status of current workout to false
    currentWorkout.isActive = false;
    // Update the database
    await dbHelper.updateWorkout(currentWorkout).then((value) {
      print(value);
    });
    notifyListeners();
  }

  Future<void> saveWorkout() async {
    print('Saving workout to database !');
    dbHelper.updateWorkout(currentWorkout);
  }

  void cancelWorkout() {
    print('Cancelling workout !');
    workouts.remove(currentWorkout);
    dbHelper.deleteWorkout(currentWorkout);
    currentWorkout = null;
    notifyListeners();
  }

  void addWorkout(Workout value) {
    workouts.add(value);
    notifyListeners();
  }

  void removeWorkout(Workout value) {
    workouts.remove(value);
    dbHelper.deleteWorkout(value);
    notifyListeners();
  }
  
  // Returns a new instance of an exercise
  Exercise createExercise(Exercise exercise) {
    return new Exercise()
      ..name = exercise.name
      ..bodyPart = exercise.bodyPart
      ..exerciseCategory = exercise.exerciseCategory
      ..notes = exercise.notes;
  }

  void addExercises(List<Exercise> exercises) {
    exercises.map((ex) {
      return selectedExercises.add(createExercise(ex));
    }).toList();

    initializeFirstSets(selectedExercises);
    currentWorkout.exercises.addAll(selectedExercises);
    selectedExercises.clear();

    // Save the workout to db when exercise/s added
    saveWorkout();
    notifyListeners();
  }

  void removeExercise(Exercise value) {
    if (currentWorkout.exercises.contains(value)) {
      currentWorkout.exercises.remove(value);
      // Save the workout to db when checked
      saveWorkout();
      notifyListeners();
    }
  }

  void replaceExercise(Exercise oldExercise, Exercise newExercise) {
    if (currentWorkout.exercises.contains(oldExercise)) {
      // Get the index of old exercise
      int index = currentWorkout.exercises.indexOf(oldExercise);
      print('Exercise to be replace at $index');

      // Remove the old exercise
      currentWorkout.exercises.remove(oldExercise);
      
      // Initialize first set of new exercise
      newExercise = initializeFirstSet(createExercise(newExercise));

      // Insert the new exercise at oldExercise's index
      currentWorkout.exercises.insert(index, newExercise);

      // Save the workout to db when exercise is replaced
      saveWorkout();
      notifyListeners();
    }
  }

  void initializeFirstSets(List<Exercise> exercises) {
    exercises.forEach(
        (exercise) => exercise.exerciseSets = [new ExerciseSet(index: 1)]);
  }

  Exercise initializeFirstSet(Exercise exercise) {
    exercise.exerciseSets = [new ExerciseSet(index: 1)];
    return exercise;
  }

  void addSet(Exercise exercise) {
    if (exercise.exerciseSets == null) {
      exercise.exerciseSets = new List<ExerciseSet>();
    }
    exercise.exerciseSets
        .add(ExerciseSet(index: exercise.exerciseSets.length + 1));
    // Save the workout to db when checked
    saveWorkout();
    notifyListeners();
  }

  void completeSet() {
    saveWorkout();
  }

  void removeSet(Exercise exercise, ExerciseSet set) {
    if (exercise.exerciseSets.contains(set)) {
      exercise.exerciseSets.remove(set);
      // Save the workout to db when checked
      saveWorkout();
      notifyListeners();
    }
  }

  void updateWeight(ExerciseSet set, double value) {
    print('value is $value');
    set.weight = value;
    saveWorkout();
    //notifyListeners();
  }

  void updateRep(ExerciseSet set, int value) {
    print('value is $value');
    set.reps = value;
    saveWorkout();
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

  List<DateTime> getWorkoutDates() {
    List<DateTime> markedDates = this.workouts.map((Workout workout) {
      return workout.date;
    }).toList();
    return markedDates;
  }

  Map<DateTime, List<Workout>> getWorkoutsByDate() {
    Map<DateTime, List<Workout>> events = new Map<DateTime, List<Workout>>();

    //Loop throught the workouts
    this.workouts.map((workout) {
      // iniitalize a workout list and add workout to it
      List<Workout> workouts = [workout];

      // Extract only date from DateTime
      DateTime workoutDate =
          DateTime.parse(new DateFormat("yyyy-MM-dd").format(workout.date));

      // If a date already exists in the map as key, just add the current workout to the list(key of the map)
      if (events[workoutDate] != null) {
        events[workoutDate].add(workout);
      }

      // if the date doesn't exists, add the date as the key of the map and add the workoutList as well
      events.putIfAbsent(workoutDate, () => workouts);
    }).toList();
    return events;
  }
}
