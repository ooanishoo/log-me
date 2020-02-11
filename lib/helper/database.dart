import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'dart:async';

class DbHelper {
  DbHelper._internal();

  static DbHelper get instance => _singleton;

  static final DbHelper _singleton = DbHelper._internal();

  static Database _db;

  String dbName = 'note.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();

    return _db;
  }

  Future initDB() async {
    final documentDIR = await getApplicationDocumentsDirectory();
    final dbPath = join(documentDIR.path, dbName);
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }
}
