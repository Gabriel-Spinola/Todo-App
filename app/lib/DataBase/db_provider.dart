import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../Models/object_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider _instance = DBProvider._();

  factory DBProvider() {
    return _instance;
  }

  Future<Database> get database async {
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();

      // Change the default factory.
      databaseFactory = databaseFactoryFfi;
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Open the database and store the reference.
    return openDatabase(
      join(documentsDirectory.path, 'doggie_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, creationDate TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertObject(IObjectModel object, String table) async {
    // Get a reference to the database
    final db = await _instance.database;

    // Insert an Object (Any data, like in this example a dog) into the correct table.
    // You might also specify the `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      table,
      object.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object?>>> getObjects(String table) async {
    final db = await _instance.database;

    // This is a helper to query a table and return the items found
    var res = await db.query(table);

    var resultMap = res.toList();
    return resultMap;
  }

  static Future<List<IObjectModel>> retrieveObjects(
      IObjectModel object, String table) async {
    // Get a reference to the database
    final db = await _instance.database;

    final List<Map<String, dynamic>> queryMaps = await db.query(table);

    return object.queryToList(queryMaps);
  }

  static Future<void> updateObject(IObjectModel object, String table) async {
    final db = await _instance.database;

    await db.update(
      table,
      object.toMap(),
      where: 'id=?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [object.id],
    );
  }

  static Future<void> deleteObject(int id, String table) async {
    final db = await _instance.database;

    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }
}
