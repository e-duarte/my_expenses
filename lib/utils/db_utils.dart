import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbUtils {
  static const _dbPath = 'transaction.db';
  static const _transactionTable = '''CREATE TABLE transactions(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        value REAL NOT NULL,
        date TEXT NOT NULL,
        fixed INTEGER NOT NULL,
        tag INTEGER NOT NULL,
        installments INTEGER NOT NULL,
        owner INTEGER NOT NULL,
        ownerDesc TEXT NOT NULL,
        payment INTEGER NOT NULL,
        pixDest TEXT NOT NULL,
        FOREIGN KEY (tag)
          REFERENCES tags (id)
            ON DELETE CASCADE 
            ON UPDATE NO ACTION       
      )''';
  static const _tagTable = '''CREATE TABLE tags(
        id INTEGER PRIMARY KEY,
        tag TEXT NOT NULL,
        iconPath TEXT NOT NULL,
        color TEXT NOT NULL
      )''';

  static const _settingTable = '''CREATE TABLE settings(
        id INTEGER PRIMARY KEY,
        monthValue REAL NOT NULL
      )''';

  static Future<sql.Database> database() async {
    WidgetsFlutterBinding.ensureInitialized();

    final db = await sql.openDatabase(
      join(await sql.getDatabasesPath(), _dbPath),
      onCreate: (db, version) {
        db.execute(_transactionTable);
        db.execute(_tagTable);
        db.execute(_settingTable);
      },
      version: 1,
    );

    return db;
  }

  static Future<int> insertData(String table, Map<String, Object?> data) async {
    final db = await DbUtils.database();

    return await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object?>>> listData(String table) async {
    final db = await DbUtils.database();

    return await db.query(table);
  }

  static Future<Map<String, Object?>> fetchById(String table, int id) async {
    final db = await DbUtils.database();

    final maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }

    return {};
  }

  static Future<int> updateData(String table, Map<String, Object?> data) async {
    final db = await DbUtils.database();
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  static Future<void> deleteData(
      String table, Map<String, Object?> data) async {
    final db = await DbUtils.database();

    await db.delete(table, where: 'id = ?', whereArgs: [data['id']]);
  }
}
