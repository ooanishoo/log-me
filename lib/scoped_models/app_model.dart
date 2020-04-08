import 'package:scoped_log_me/helper/database.dart';
import 'package:scoped_log_me/models/enums/exercise_category.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  List<Exercise> _exercises = [];
  List<Exercise> _selectedExercises = [];

  List<Exercise> get exercises => this._exercises;
  List<Exercise> get selectedExercises => this._selectedExercises;

  DbHelper dbHelper = DbHelper();

  AppModel() {
    this.getAllExercises();
  }

  void selectExercise(Exercise value) {
    selectedExercises.add(value);
    print("Selected Exercises is ::" + selectedExercises.length.toString());
    notifyListeners();
  }

  void unselectExercise(Exercise value) {
    selectedExercises.remove(value);
    print("Selected Exercises is ::" + selectedExercises.length.toString());
    notifyListeners();
  }

  void clearSelection() {
    selectedExercises.clear();
    exercises.forEach((exercise) => exercise.isCheck = false);
    notifyListeners();
  }

  void replaceExercise(Exercise value) {
    exercises.forEach((exercise) {
      if (exercise.isCheck == true) {
        exercise.isCheck = false;
      }
    });
    value.isCheck = true;
    selectedExercises.clear();
    this.selectExercise(value);
  }

  Future<void> addExercise(Exercise value) async {
    exercises.insert(0, value);
    value.isCheck = false;
    // int result = await databaseHelper.insertExercise(value);
    dbHelper.insert(value);
    //dbHelper.insert2(value);
    notifyListeners();

    // if (result != 0) {
    //   notifyListeners();
    // }
  }

  Future<void> updateExercise(Exercise value) async {
    value.isCheck = false;
    dbHelper.update(value);
    //notifyListeners();
  }

  void removeExercise(Exercise value) {
    exercises.remove(value);
    dbHelper.delete(value);
    notifyListeners();
  }

  void updateExerciseCategory(
      Exercise exercise, ExerciseCategory exerciseCategory) {
    exercise.exerciseCategory = exerciseCategory;
  }

  void getAllExercises() async {
    // Fetch all the exercises from database
    // List<Exercise> exerciseList2 = await databaseHelper.getExerciseList();

    // Fetch all the exercises from database
    List<Exercise> exerciseList = await dbHelper.getAllExercises();

    print('size is ************');
    print(exerciseList.length.toString());

    // Set isCheck to false for exercise selection
    exerciseList.forEach((ex) => ex.isCheck = false);

    // set the list to appModel's exerciseList
    _exercises = exerciseList;
    notifyListeners();
  }
}
