import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  List<Exercise> _exercises = [];
  List<Exercise> _selectedExercises = [];

  List<Exercise> get exercises => this._exercises;
  List<Exercise> get selectedExercises => this._selectedExercises;

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

  void addExercise(Exercise value) {
    exercises.insert(0, value);
    print(exercises.length.toString());
    notifyListeners();
  }

  void removeExercise(Exercise value) {
    exercises.remove(value);
    notifyListeners();
  }

  void getAllExercises() {
    final List<Map<String, dynamic>> exercises = [
      {"name": "barbell side split squat", "isCheck": false},
      {"name": "barbell squat", "isCheck": false},
      {"name": "barbell squat to a bench", "isCheck": false},
      {"name": "barbell step ups", "isCheck": false},
      {"name": "barbell walking lunge", "isCheck": false},
      {"name": "battling ropes", "isCheck": false},
      {"name": "bear crawl sled drags", "isCheck": false},
      {"name": "behind head chest stretch", "isCheck": false},
      {"name": "bench dips", "isCheck": false},
      {"name": "bench jump", "isCheck": false},
      {"name": "bench press - powerlifting", "isCheck": false},
      {"name": "bench press - with bands", "isCheck": false},
      {"name": "bench press with chains", "isCheck": false},
      {"name": "bench sprint", "isCheck": false},
      {"name": "bent over barbell row", "isCheck": false},
      {"name": "bent over dumbbell", "isCheck": false},
      {"name": "bent over low-pulley side lateral", "isCheck": false},
      {"name": "bent over one-arm long bar row", "isCheck": false},
      {"name": "bent over two-arm long bar row", "isCheck": false},
      {"name": "bent over two-dumbbell row", "isCheck": false},
      {"name": "bent over two-dumbbell row with palms in", "isCheck": false},
      {"name": "bent press", "isCheck": false},
      {"name": "bent-arm barbell pullover", "isCheck": false},
      {"name": "bent-arm dumbbell pullover", "isCheck": false},
      {"name": "bent-knee hip raise", "isCheck": false},
      {"name": "bicycling", "isCheck": false},
      {"name": "bicycling stationary", "isCheck": false},
      {"name": "board press", "isCheck": false},
      {"name": "body tricep press", "isCheck": false},
      {"name": "body-up", "isCheck": false},
      {"name": "bodyweight flyes", "isCheck": false},
      {"name": "bodyweight mid row", "isCheck": false},
      {"name": "bodyweight squat", "isCheck": false},
      {"name": "bodyweight walking lunge", "isCheck": false},
      {"name": "bosu ball cable crunch with side bends", "isCheck": false},
      {"name": "bottoms up", "isCheck": false}
    ];

    exercises.forEach(
        (exerciseJson) => _exercises.add(Exercise.fromJson(exerciseJson)));
  }
}
