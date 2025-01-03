import 'package:budget_tracker_app/model/category_model.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  //singleton object
  static DBHelper dbHelper = DBHelper._();

  Database? database;
  static Logger logger = Logger();
  String tableName = 'category';
  String name = 'category_name';
  String image = 'category_image';

  // create database
  Future<void> initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = '$dbPath/expense.db';

    //create table
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) {
        String query = ''' CREATE TABLE $tableName(
          category_id INTEGER PRIMARY KEY AUTOINCREMENT,
          $name TEXT NOT NULL,
          $image BLOB NOT NULL
        );''';

        db
            .execute(query)
            .then(
              (value) => logger.i("Table Created"),
            )
            .onError((error, _) => logger.e(error.toString()));
      },
    );
  }

  //insert data
  Future<int?> insertData({
    required String name,
    required Uint8List image,
  }) async {
    if (database == null) await initDatabase();
    String query =
        "INSERT INTO $tableName(${this.name}, ${this.image}) VALUES(?, ?);";
    List values = [name, image];
    try {
      int? result = await database?.rawInsert(query, values);
      logger.i("Insert Success: ID $result");
      return result;
    } catch (e) {
      logger.e("Insert failed: $e");
      return null;
    }
  }

  //get all data
  Future<List<CategoryModel>> getAllData() async {
    await initDatabase();
    String query = "SELECT * FROM $tableName";
    List<Map<String, dynamic>> result = await database?.rawQuery(query) ?? [];
    return result
        .map((Map<String, dynamic> e) => CategoryModel.fromMap(map: e))
        .toList();
  }

  //Search Category
  Future<List<CategoryModel>> searchCategory({required String search}) async {
    await initDatabase();
    String query = "SELECT * FROM $tableName WHERE $name LIKE '%$search%'";
    List<Map<String, dynamic>> result = await database?.rawQuery(query) ?? [];
    return result
        .map((Map<String, dynamic> e) => CategoryModel.fromMap(map: e))
        .toList();
  }
}
