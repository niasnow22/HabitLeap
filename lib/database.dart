import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, filePath);

    return await openDatabase(
      path,
      version: 3, // Increment version for new columns
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        frequency TEXT NOT NULL,
        day TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        priority TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0
      );
    ''');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute("ALTER TABLE tasks ADD COLUMN isCompleted INTEGER DEFAULT 0");
    }
  }

  // --- USER FUNCTIONS ---
  Future<int> createUser(String username, String password) async {
    final db = await database;
    return await db.insert('users', {
      'username': username,
      'password': password,
    });
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // --- HABIT FUNCTIONS ---
  Future<int> addHabit(int userId, String title, String description, String frequency, String day) async {
    final db = await database;
    return await db.insert('habits', {
      'user_id': userId,
      'title': title,
      'description': description,
      'frequency': frequency,
      'day': day,
    });
  }

  Future<List<Map<String, dynamic>>> fetchHabits(int userId, {String dayFilter = "All Days"}) async {
    final db = await database;

    if (dayFilter == "All Days") {
      return await db.query('habits', where: 'user_id = ?', whereArgs: [userId]);
    }

    return await db.query('habits', where: 'user_id = ? AND day = ?', whereArgs: [userId, dayFilter]);
  }

  Future<int> deleteHabit(int id) async {
    final db = await database;
    return await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  // --- TASK FUNCTIONS ---
  Future<int> insertTask(String description, String date, String time, String priority, {bool isCompleted = false}) async {
    final db = await database;
    return await db.insert(
      'tasks',
      {
        'description': description,
        'date': date,
        'time': time,
        'priority': priority,
        'isCompleted': isCompleted ? 1 : 0, // Store as INTEGER (1 = completed, 0 = not completed)
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Prevent duplicate errors
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTask(int id, bool isCompleted) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
