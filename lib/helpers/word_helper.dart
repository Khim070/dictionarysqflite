import 'package:flutter/foundation.dart';
import 'package:localsqflite/models/word_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class WordHelper {
  late Database db;

  Future openDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, databaseName);
    db = await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnEnglish TEXT NOT NULL,
      $columnKhmer TEXT NOT NULL
        )
    ''');
  }

  Future<WordModel> insert(WordModel wordModel) async {
    wordModel.id = await db.insert(tableName, wordModel.toMap);
    return wordModel;
  }

  Future<int> update(WordModel wordModel) async {
    return await db.update(
      tableName,
      wordModel.toMap,
      where: '$columnId=?',
      whereArgs: [wordModel.id],
    );
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableName,
      where: '$columnId=?',
      whereArgs: [id],
    );
  }

  Future<List<WordModel>> selectAll() async {
    List list = await db.query(tableName);
    return compute(_parseData, list);
  }

  Future close() async => db.close();

  Future<List<Map<String, Object?>>> rawQuery(String sql) {
    return db.rawQuery(sql);
  }

  List<WordModel> _parseData(List list) {
    return list.map((e) => WordModel.fromMap(e)).toList();
  }
}
