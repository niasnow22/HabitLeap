import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, fileName);

    return await openDatabase(
      path,
      version: 2, // Updated version number
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("DROP TABLE IF EXISTS users");
          await _createDB(db, newVersion);
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<int> insertUser(String username, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);
    return await db.insert(
      'users',
      {'username': username, 'password': hashedPassword},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> authenticateUser(String username, String password) async {
    final db = await database;
    final hashedPassword = _hashPassword(password);
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<void> close() async {
    final db = await database;
    await db.close(); // Ensuring database closure is awaited
  }
}
