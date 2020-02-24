import 'package:scoped_log_me/models/exercise.dart';
import 'package:scoped_log_me/models/workout.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'dart:async';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _db;

  DbHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _dbHelper;
  }

  DbHelper._();

  String dbName = 'logMe.db';

  static const String STORE_WORKOUT = 'workout';
  static const String STORE_EXERCISE = 'exercise';
  static const String STORE_ROUTINE = 'routine';
  static const String STORE_WORKOUT_PLAN = 'workout_plan';

  final _exerciseStore = intMapStoreFactory.store(STORE_EXERCISE);
  final _workoutStore = intMapStoreFactory.store(STORE_WORKOUT);
  final _routineStore = intMapStoreFactory.store(STORE_ROUTINE);
  final _workoutPlanStore = intMapStoreFactory.store(STORE_WORKOUT_PLAN);

  // get the database
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();

    return _db;
  }

  // Initialize database
  Future initDB() async {
    final documentDIR = await getApplicationDocumentsDirectory();
    final dbPath = join(documentDIR.path, dbName);
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }

  Future initExercises() async {
    await _db.transaction((txn) async {
      await _exerciseStore.add(txn, {'name': 'fish'});
    });
  }

  Future insert(Exercise exercise) async {
    await _exerciseStore.add(await db, exercise.toMap());
  }

  Future insertWorkout(Workout workout) async {
    await _workoutStore.add(await db, workout.toMap());
  }

  Future delete(Exercise exercise) async {
    final finder = Finder(filter: Filter.byKey(exercise.id));
    await _exerciseStore.delete(
      await _db,
      finder: finder,
    );
  }
  Future deleteWorkout(Workout workout) async {
    final finder = Finder(filter: Filter.byKey(workout.id));
    await _workoutStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future update(Exercise exercise) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(exercise.id));
    await _exerciseStore.update(
      await _db,
      exercise.toMap(),
      finder: finder,
    );
  }

  Future updateWorkout(Workout workout) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(workout.id));
    await _workoutStore.update(
      await _db,
      workout.toMap(),
      finder: finder,
    );
  }

  Future<List<Exercise>> getAllExercises() async {
    final finder = Finder(sortOrders: [SortOrder('name')]);
    final snapshot = await _exerciseStore.find(await db, finder: finder);

    return snapshot.map((map) {
      final exercise = Exercise.fromMap(map.value);

      exercise.id = map.key;
      return exercise;
    }).toList();
  }

  Future<List<Workout>> getAllWorkouts() async {
    final finder = Finder(
        //filter: Filter.equals('isActive', false),
        sortOrders: [SortOrder('date')]);

    final snapshot = await _workoutStore.find(await db, finder: finder);

    return snapshot.map((map) {
      final workout = Workout.fromMap(map.value);

      workout.id = map.key;
      return workout;
    }).toList();
  }

  Future<Workout> getCurrentWorkout() async {
    final finder = Finder(filter: Filter.equals('isActive', true));

    final snapshot = await _workoutStore.findFirst(await db, finder: finder);
    if (snapshot != null) {
      final workout = Workout.fromMap(snapshot.value);
      workout.id = snapshot.key;
      print('Current workout NAME ::' + workout.name.toString());
      return workout;
    } else {
      print('No Current workout');
      return null;
    }
  }
}
