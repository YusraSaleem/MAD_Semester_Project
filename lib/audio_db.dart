import 'package:path/path.dart';
import 'package:sound_sweep/audio.dart';
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
    );
    return db;
  }

  Future<List<Audio>> getAllAudios() async {
    //!!
    final db = await database; //getter method called here to get instance of db
    final audioMaps =
        await db.query(_tableName); //db.query() means select * from table
    List<Audio> audios = [];

    for (var map in audioMaps) {
      var audio = Audio.fromMap(map);
      audios.add(audio);
    }
    return audios;
  }

  insertAudio(Audio audio) async {
    final db = await database;
    await db.insert(
      _tableName,
      audio.toMap(), //helper method that we created
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  deleteAudio(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: "$_columnId = ?",
      whereArgs: [id],
    );
  }
}
