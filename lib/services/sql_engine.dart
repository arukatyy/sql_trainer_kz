import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/query_result.dart';
import '../data/databases/sample_databases.dart';

class SqlEngine {
  Database? _db;
  String? _currentDbName;

  Future<void> _initDatabase(String dbName) async {
    const targetDb = 'sql_trainer';
    if (_db != null && _currentDbName == targetDb) return;

    if (_db != null) {
      await _db!.close();
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sql_trainer_test.db');
    
    // Delete existing to start fresh
    await deleteDatabase(path);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Initialize schema and data
        final initScript = sampleDatabases['sql_trainer'];
        if (initScript != null) {
          final statements = initScript.split(';');
          for (var statement in statements) {
            if (statement.trim().isNotEmpty) {
              await db.execute(statement);
            }
          }
        }
      },
    );
    _currentDbName = targetDb;
  }

  Future<QueryResult> executeQuery(String query, String dbName) async {
    try {
      await _initDatabase(dbName);
      // For SELECT queries, use rawQuery. For others (INSERT/UPDATE/DELETE), use execute/rawQuery
      // We will assume most tasks are SELECT for now. 
      // If the query contains SELECT at start, we use rawQuery
      final q = query.trim().toUpperCase();
      if (q.startsWith('SELECT') || q.startsWith('WITH')) {
        final result = await _db!.rawQuery(query);
        return QueryResult.fromList(result);
      } else {
        await _db!.execute(query);
        return QueryResult(columns: ['Нәтиже'], rows: [['Сұраныс сәтті орындалды']]);
      }
    } catch (e) {
      return QueryResult.error(e.toString().replaceAll('DatabaseException', '').trim());
    }
  }

  Future<bool> checkAnswer(String userQuery, String expectedQuery, String dbName) async {
    final userResult = await executeQuery(userQuery, dbName);
    // Execute expected query on a fresh database to avoid side effects from user query
    // if the user query was an UPDATE/INSERT/DELETE
    if (userQuery.trim().toUpperCase().startsWith('SELECT') == false) {
      await _initDatabase(dbName); // Reset db
    }
    
    final expectedResult = await executeQuery(expectedQuery, dbName);

    if (userResult.hasError || expectedResult.hasError) return false;

    // Compare results
    if (userResult.rows.length != expectedResult.rows.length) return false;
    
    // We can do a simple string comparison of rows for now
    for (int i = 0; i < expectedResult.rows.length; i++) {
      final userRow = userResult.rows[i].map((e) => e.toString()).toList();
      final expectedRow = expectedResult.rows[i].map((e) => e.toString()).toList();
      
      if (userRow.length != expectedRow.length) return false;
      
      for(int j = 0; j < expectedRow.length; j++) {
        if (userRow[j] != expectedRow[j]) return false;
      }
    }

    return true;
  }
}
