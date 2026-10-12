import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _db;

  static Future<Database?> get db async {
    if (kIsWeb) return null;
    if (_db != null && _db!.isOpen) return _db!;
    _db = await initDb();
    return _db;
  }

  static Future<Database?> initDb() async {
    if (kIsWeb) return null;
    try {
      String dbPath;
      final projectRootDb = File('/Users/air/Desktop/sql_trainer_kz2/sql_trainer.db');
      if (Platform.isMacOS && projectRootDb.existsSync()) {
        dbPath = projectRootDb.path;
      } else {
        dbPath = join(await getDatabasesPath(), 'sql_trainer.db');
      }

      return await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          await _createTables(db);
        },
      );
    } catch (e) {
      debugPrint("DB init error: $e");
      return null;
    }
  }

  static Future<void> _createTables(Database database) async {
    // 1. users table
    await database.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        total_xp INTEGER DEFAULT 0,
        streak_days INTEGER DEFAULT 0,
        level INTEGER DEFAULT 1,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    // 2. user_progress table
    await database.execute('''
      CREATE TABLE IF NOT EXISTS user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        task_id INTEGER NOT NULL,
        status TEXT NOT NULL,
        completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(user_id) REFERENCES users(id)
      );
    ''');

    // 3. students table
    await database.execute('''
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER,
        city TEXT,
        specialty TEXT,
        gpa DECIMAL
      );
    ''');

    // 4. teachers table
    await database.execute('''
      CREATE TABLE IF NOT EXISTS teachers (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        department TEXT
      );
    ''');

    // 5. courses table
    await database.execute('''
      CREATE TABLE IF NOT EXISTS courses (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        teacher_id INTEGER,
        FOREIGN KEY(teacher_id) REFERENCES teachers(id)
      );
    ''');

    // 6. grades table
    await database.execute('''
      CREATE TABLE IF NOT EXISTS grades (
        student_id INTEGER,
        course_id INTEGER,
        grade INTEGER,
        FOREIGN KEY(student_id) REFERENCES students(id),
        FOREIGN KEY(course_id) REFERENCES courses(id)
      );
    ''');

    // Seed default data
    await database.execute('''
      INSERT OR IGNORE INTO users (id, name, email, password, total_xp, streak_days, level) VALUES
      (1, 'Аружан', 'aruzhan@mail.kz', '123456', 240, 5, 2),
      (2, 'Данияр', 'daniyar@gmail.com', 'qwerty', 80, 2, 1),
      (3, 'Студент', 'student@mail.kz', 'student123', 0, 1, 1);
    ''');

    await database.execute('''
      INSERT OR IGNORE INTO students (id, name, age, city, specialty, gpa) VALUES
      (1, 'Аружан', 17, 'Astana', 'IT', 3.7),
      (2, 'Алина', 18, 'Almaty', 'Design', 3.9),
      (3, 'Данияр', 19, 'Astana', 'Math', 3.4),
      (4, 'Мадина', 20, 'Shymkent', 'IT', 3.8),
      (5, 'Санжар', 21, 'Almaty', 'IT', 3.2),
      (6, 'Айгерім', 18, 'Astana', 'Design', 3.95),
      (7, 'Бауыржан', 22, 'Karaganda', 'Math', 3.1),
      (8, 'Дильназ', 19, 'Aktobe', 'IT', 3.65);
    ''');

    await database.execute('''
      INSERT OR IGNORE INTO teachers (id, name, department) VALUES
      (1, 'Иван', 'IT'),
      (2, 'Сара', 'Math'),
      (3, 'Нұрлан', 'IT'),
      (4, 'Айгүл', 'Design');
    ''');

    await database.execute('''
      INSERT OR IGNORE INTO courses (id, name, teacher_id) VALUES
      (1, 'Databases', 1),
      (2, 'Calculus', 2),
      (3, 'Python Programming', 3),
      (4, 'UI/UX Design', 4);
    ''');

    await database.execute('''
      INSERT OR IGNORE INTO grades (student_id, course_id, grade) VALUES
      (1, 1, 95), (2, 1, 88), (3, 2, 75), (4, 1, 100), (5, 3, 82), (6, 4, 91), (7, 2, 68), (8, 1, 85);
    ''');
  }

  // --- Auth & User Methods ---

  static Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final database = await db;
    if (database != null) {
      try {
        final existing = await database.query('users', where: 'email = ?', whereArgs: [email]);
        if (existing.isNotEmpty) {
          return false; // Email already in use
        }
        await database.insert('users', {
          'name': name,
          'email': email,
          'password': password,
          'total_xp': 0,
          'streak_days': 1,
          'level': 1,
          'created_at': DateTime.now().toIso8601String(),
        });
        return true;
      } catch (e) {
        debugPrint("Error registering user in SQLite: $e");
        return false;
      }
    }
    return true; // Fallback handles web
  }

  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final database = await db;
    if (database != null) {
      try {
        final cleanEmail = email.trim().toLowerCase();
        final cleanPassword = password.trim().replaceAll("'", "");
        final results = await database.query(
          'users',
          where: 'LOWER(email) = ?',
          whereArgs: [cleanEmail],
        );
        for (final row in results) {
          final storedPass = row['password']?.toString().trim().replaceAll("'", "");
          if (storedPass == cleanPassword) {
            return row;
          }
        }
      } catch (e) {
        debugPrint("Error logging in SQLite: $e");
      }
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final database = await db;
    if (database != null) {
      try {
        final results = await database.query('users', where: 'email = ?', whereArgs: [email]);
        if (results.isNotEmpty) return results.first;
      } catch (e) {
        debugPrint("Error fetching user: $e");
      }
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await db;
    if (database != null) {
      try {
        return await database.query('users');
      } catch (e) {
        debugPrint("Error query users: $e");
      }
    }
    return [];
  }

  // --- Query execution helper ---
  static Future<List<Map<String, dynamic>>> executeQuery(String query) async {
    final database = await db;
    if (database == null) {
      return [{'Result': 'Web mode немесе дерекқор қолжетімсіз'}];
    }
    if (query.trim().toUpperCase().startsWith('SELECT')) {
      return await database.rawQuery(query);
    } else {
      await database.execute(query);
      return [{'Result': 'Сұраныс сәтті орындалды!'}];
    }
  }
}
