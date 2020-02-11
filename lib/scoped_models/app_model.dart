import 'package:scoped_log_me/helper/database_helper.dart';
import 'package:scoped_log_me/models/category.dart';
import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  List<Exercise> _exercises = [];
  List<Exercise> _selectedExercises = [];

  List<Exercise> get exercises => this._exercises;
  List<Exercise> get selectedExercises => this._selectedExercises;

  DatabaseHelper databaseHelper = DatabaseHelper();

  void addExerciseToDB(Exercise exercise) async {
    exercise.isCheck = false;
    int result;
    result = await databaseHelper.insertExercise(exercise);
    print(result);
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

  Future<void> addExercise(Exercise value) async {
    exercises.insert(0, value);
    value.isCheck = false;
    int result = await databaseHelper.insertExercise(value);
    if (result != 0) {
      notifyListeners();
    }
  }

  void removeExercise(Exercise value) {
    exercises.remove(value);
    databaseHelper.deleteExercise(value.id);
    notifyListeners();
  }

  void updateExerciseCategory(Exercise exercise, Category category) {
    exercise.category = category;
  }

  void getAllExercises() async {
    // Fetch all the exercises from database
    List<Exercise> exerciseList = await databaseHelper.getExerciseList();

    // Set isCheck to false for exercise selection
    exerciseList.forEach((ex) => ex.isCheck = false);

    // set the list to appModel's exerciseList
    _exercises = exerciseList;
    notifyListeners();
  }
}
