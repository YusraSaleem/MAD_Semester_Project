import 'package:path/path.dart';
import 'package:project_new/audio.dart';
import 'package:sqflite/sqflite.dart';

class AudioDatabase {
  static const _dbName = 'audio.db';
  static const _tableName = 'Audios';
  static const _columnId = 'id';
  static const _columnName = 'name';
  static const _columnpath = 'path';

//like a singleton design pattern, same concept, if null then create new, otherwise use old one
//so that DB instances is only once created, otherwise conflict will occure
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      try {
        _database = await _initDatabase();
      } catch (e) {
        print(e);
        rethrow;
      }
    }
    if (_database == null) {
      throw Exception("Database can't be iniialized");
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE $_tableName ($_columnId INTEGER PRIMARY KEY AUTOINCREMENT, $_columnName TEXT NOT NULL, $_columnpath TEXT NOT NULL)");
      },
      version: 1,

      ///to show changes, like github, good practice to make it
    );
    //openDB->first time, it will create todo.db in new file, otherwise it will open same file. this process may have different methods to do

    return db;
  }

  Future<List<Audio>> getAllAudios() async {
    //!!
    final db = await database; //getter method called here to get instance of db
    final audioMaps =
        await db.query(_tableName); //db.query() means select * from table
    // OR CAN DO THIS ALSO final todoMaps = await db.query(_tableName, columns=['id','title']);

    List<Audio> audios = [];

    for (var map in audioMaps) {
      var audio = Audio.fromMap(map);
      //todoMaps gets all data, then these maps are passed to our method to convert them in obj one by one
      audios.add(audio);
    }
    return audios;
  }

  insertAudio(Audio audio) async {
    final db = await database;
    await db.insert(
      //better to use these methods, writing the wholr query can have have errors which compipler can't tell us
      _tableName,
      audio.toMap(), //helper method that we created
      conflictAlgorithm: ConflictAlgorithm
          .replace, //incase same id pe data jaye tou kiya karna hai
    );
  }

  updateTodo(Audio audio) async {
    final db = await database;
    return await db.update(
      _tableName,
      audio.toMap(), //data going to DB in a map format
      where: "$_columnId = ?",
      // can use todo.id instead of ? but increases chances of SQL injection,
      //this ? means the first value in where args array, multiple ???? corrsponds to 1st,2nd,etc values of where args
      whereArgs: [audio.id],
    );
  }

  deleteAudio(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: "$_columnId = ?",
      whereArgs: [id], //if we pass Todo todo in method then todo.id here
    );
  }

  // deleteAll() async {
  //   final db = await database;
  //   return db.delete(_tableName); //will delete complete data of table
  // }
}
