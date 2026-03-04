import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sembast_sqflite/sembast_sqflite.dart';
import 'package:sembast_web/sembast_web.dart';

import 'package:sqflite/sqflite.dart' as sqflite;



class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  // Stores (like tables)
  final StoreRef<int, Map<String, dynamic>> _usersStore =
      intMapStoreFactory.store('users');
  final StoreRef<int, Map<String, dynamic>> _habitsStore =
      intMapStoreFactory.store('habits');
  final StoreRef<int, Map<String, dynamic>> _tasksStore =
      intMapStoreFactory.store('tasks');

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('app_database.sembast');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
  if (kIsWeb) {
    // 🌐 Web → IndexedDB
    return databaseFactoryWeb.openDatabase(fileName);
  } else {
    // 📱 Mobile → SQLite via sqflite (used internally by sembast)
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, fileName);

    return getDatabaseFactorySqflite(sqflite.databaseFactory)
        .openDatabase(dbPath);
  }
}



  // --------------------
  // USER FUNCTIONS
  // --------------------
  Future<int> createUser(String username, String password) async {
    final db = await database;

    final id = await _usersStore.add(db, {
      'username': username,
      'password': password,
    });

    await _usersStore.record(id).update(db, {'id': id});
    return id;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    final records = await _usersStore.find(db);

    return records.map((r) {
      final data = Map<String, dynamic>.from(r.value);
      data['id'] = r.key;
      return data;
    }).toList();
  }

  // --------------------
  // HABIT FUNCTIONS
  // --------------------
  Future<int> addHabit(
    int userId,
    String title,
    String description,
    String frequency,
    String day,
  ) async {
    final db = await database;

    final id = await _habitsStore.add(db, {
      'user_id': userId,
      'title': title,
      'description': description,
      'frequency': frequency,
      'day': day,
      'completed': false, // ✅ NEW
    });

    await _habitsStore.record(id).update(db, {'id': id});
    return id;
  }

  // All habits for a specific user (with optional day filter)
  Future<List<Map<String, dynamic>>> fetchHabits(
    int userId, {
    String dayFilter = "All Days",
  }) async {
    final db = await database;

    final filters = <Filter>[Filter.equals('user_id', userId)];
    if (dayFilter != "All Days") {
      filters.add(Filter.equals('day', dayFilter));
    }

    final finder = Finder(filter: Filter.and(filters));
    final records = await _habitsStore.find(db, finder: finder);

    return records.map((r) {
      final data = Map<String, dynamic>.from(r.value);
      data['id'] = r.key;
      data['completed'] = data['completed'] ?? false; // ✅ normalize
      return data;
    }).toList();
  }

  // ✅ All habits (no user filter) - matches old db.query('habits')
  Future<List<Map<String, dynamic>>> fetchAllHabits() async {
    final db = await database;
    final records = await _habitsStore.find(db);

    return records.map((r) {
      final data = Map<String, dynamic>.from(r.value);
      data['id'] = r.key;
      data['completed'] = data['completed'] ?? false;
      return data;
    }).toList();
  }

  Future<int> deleteHabit(int id) async {
    final db = await database;
    await _habitsStore.record(id).delete(db);
    return 1;
  }

  // ✅ Update one habit completion (checkbox support)
  Future<int> updateHabitCompleted(int habitId, bool completed) async {
    final db = await database;
    await _habitsStore.record(habitId).update(db, {'completed': completed});
    return 1;
  }

  // ✅ Mark habits completed for a specific user (optional day filter)
  Future<void> markAllHabitsCompleted(int userId, {String? day}) async {
    final db = await database;

    final filters = <Filter>[Filter.equals('user_id', userId)];
    if (day != null && day != "All Days") {
      filters.add(Filter.equals('day', day));
    }

    final finder = Finder(filter: Filter.and(filters));

    await _habitsStore.update(
      db,
      {'completed': true},
      finder: finder,
    );
  }

  // ✅ Mark ALL habits completed (no user filter)
  Future<void> markAllHabitsCompletedAllUsers() async {
    final db = await database;
    await _habitsStore.update(db, {'completed': true});
  }

  // --------------------
  // TASK FUNCTIONS
  // --------------------
  Future<int> insertTask(
    String description,
    String date,
    String time,
    String priority, {
    bool isCompleted = false,
  }) async {
    final db = await database;

    final id = await _tasksStore.add(db, {
      'description': description,
      'date': date,
      'time': time,
      'priority': priority,
      'isCompleted': isCompleted,
    });

    await _tasksStore.record(id).update(db, {'id': id});
    return id;
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;

    final finder = Finder(
      sortOrders: [SortOrder('date'), SortOrder('time')],
    );

    final records = await _tasksStore.find(db, finder: finder);

    return records.map((r) {
      final data = Map<String, dynamic>.from(r.value);
      data['id'] = r.key;

      final v = data['isCompleted'];
      if (v is int) data['isCompleted'] = (v == 1);

      return data;
    }).toList();
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    await _tasksStore.record(id).delete(db);
    return 1;
  }

  Future<int> updateTask(int id, bool isCompleted) async {
    final db = await database;
    await _tasksStore.record(id).update(db, {'isCompleted': isCompleted});
    return 1;
  }
}
