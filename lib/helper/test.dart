// import 'package:scoped_log_me/models/exercise.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
//   static Database _database; // Singleton Database

//   String exerciseTable = 'exercise_table';
//   String colId = 'id';
//   String colName = 'name';
//   String colDate = 'date';
//   String colCategory = 'exerciseCategory';
//   String colBodyPart = 'bodyPart';
//   String colIsActive = 'isActive';
//   String workoutTable = 'workout_table';

//   DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

//   factory DatabaseHelper() {
//     if (_databaseHelper == null) {
//       _databaseHelper = DatabaseHelper
//           ._createInstance(); // This is executed only once, singleton object
//     }
//     return _databaseHelper;
//   }

//   Future<Database> get database async {
//     if (_database == null) {
//       _database = await initializeDatabase();
//     }
//     return _database;
//   }

//   Future<Database> initializeDatabase() async {
//     // Get the directory path for both Android and iOS to store database.
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = directory.path + 'logme.db';

//     // Open/create the database at a given path
//     var database = await openDatabase(path, version: 1, onCreate: _createDb);
//     return database;
//   }

//   void _createDb(Database db, int newVersion) async {
//     await db.execute(
//       'CREATE TABLE $exerciseTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colCategory TEXT, $colBodyPart TEXT)',);
//     await db.execute(
//       'CREATE TABLE $workoutTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colIsActive TEXT, $colDate TEXT)',);
//   }

//   // Fetch Operation: Get all exercise objects from database
//   Future<List<Map<String, dynamic>>> getExerciseMapList() async {
//     Database db = await this.database;

// //		var result = await db.rawQuery('SELECT * FROM $exerciseTable order by $colTitle ASC');
//     var result = await db.query(exerciseTable, orderBy: '$colName ASC');
//     return result;
//   }

//   // Insert Operation: Insert a exercise object to database
//   // Insert Operation: describeInsert a exercise object to database
//   Future<int> insertExercise(Exercise exercise) async {
//     Database db = await this.database;
//     var result = await db.insert(exerciseTable, exercise.toMap());
//     return result;
//   }

//   // Update Operation: Update a exercise object and save it to database
//   Future<int> updateExercise(Exercise exercise) async {
//     var db = await this.database;
//     var result = await db.update(exerciseTable, exercise.toMap(),
//         where: '$colId = ?', whereArgs: [exercise.id]);
//     return result;
//   }

//   Future<int> updateExerciseCompleted(Exercise exercise) async {
//     var db = await this.database;
//     var result = await db.update(exerciseTable, exercise.toMap(),
//         where: '$colId = ?', whereArgs: [exercise.id]);
//     return result;
//   }

//   // Delete Operation: Delete a exercise object from database
//   Future<int> deleteExercise(int id) async {
//     var db = await this.database;
//     int result =
//         await db.rawDelete('DELETE FROM $exerciseTable WHERE $colId = $id');
//     return result;
//   }

//   // Get number of exercise objects in database
//   Future<int> getCount() async {
//     Database db = await this.database;
//     List<Map<String, dynamic>> x =
//         await db.rawQuery('SELECT COUNT (*) from $exerciseTable');
//     int result = Sqflite.firstIntValue(x);
//     return result;
//   }

//   // Get the 'Map List' [ List<Map> ] and convert it to 'exercise List' [ List<Exercise> ]
//   Future<List<Exercise>> getExerciseList() async {
//     var exerciseMapList =
//         await getExerciseMapList(); // Get 'Map List' from database
//     int count =
//         exerciseMapList.length; // Count the number of map entries in db table

//     List<Exercise> exerciseList = List<Exercise>();
//     // For loop to create a 'exercise List' from a 'Map List'
//     for (int i = 0; i < count; i++) {
//       exerciseList.add(Exercise.fromMap(exerciseMapList[i]));
//     }

//     return exerciseList;
//   }
// }
