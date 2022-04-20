import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/task_model.dart';

class DBProvider {
  // The `._()` makes this constructor non-instantiable
  DBProvider._();

  // NOTE Using the Singleton pattern, I don't know if this is good :()

  static final DBProvider dataBase = DBProvider._();

  // REVIEW Another problem, but now with null validation, I have added the `?` mark, but I don't know much on how it works
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return await openDatabase(
      // REVIEW This path thing seems unreliable
      join(await getDatabasesPath(), 'todo_app_db.db'),
      // This property will execute a function when the db is created
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, creationDate TEXT)''',
        );
      },
      version: 1,
    );
  }

  void addNewTask(Task newTask) async {
    final db = await database;

    db!.insert(
      "tasks",
      newTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<dynamic> getTask() async {
    final db = await database;

    // This is a helper to query a table and return the items found
    var res = await db!.query("tasks");

    if (res.length == 0) {
      return Null;
    } else {
      var resultMap = res.toList();

      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }
}
