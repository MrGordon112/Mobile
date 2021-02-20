import 'dart:io';

import 'package:path/path.dart';
import "package:sqflite/sqflite.dart";
import "package:sqflite/sqlite_api.dart";

Database db;

class DBCreator {
  static const carTable = 'carTable';
  static const id = 'id';
  static const String license = 'license';
  static const String statuses = 'statuses';
  static const String drivers = 'drivers';
  static const String colors = 'colors';
  static const String seats= 'seats';
  static const String cargo = 'cargo';

  Future<void> createCarTable(Database db) async {
    final sql = '''CREATE TABLE $carTable
    (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $license VARCHAR(64),
      $statuses VARCHAR(128),
      $drivers VARCHAR(128),
      $colors VARCHAR(128),
      $seats INTEGER,
      $cargo INTEGER
      
    )''';
    await db.execute(sql);
  }

  Future<String> getDBPath(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    if (await Directory(dirname(path)).exists()) {
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDB() async {
    final path = await getDBPath('car_db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {
    await createCarTable(db);
  }
}
