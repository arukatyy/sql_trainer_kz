import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_helper.dart';
import 'web_sync.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _registeredUsersKey = 'registered_users_map';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<bool> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();
    final cleanName = name.trim();

    // Password policy: minimum 6 characters, at least 1 digit, at least 1 symbol
    if (cleanPassword.length < 6 ||
        !RegExp(r'[0-9]').hasMatch(cleanPassword) ||
        !RegExp(r'[^\p{L}\p{N}\s]', unicode: true).hasMatch(cleanPassword)) {
      return false;
    }

    // 1. Try to register directly in SQLite sql_trainer.db
    final dbRegistered = await DbHelper.registerUser(
      name: cleanName,
      email: cleanEmail,
      password: cleanPassword,
    );

    if (!dbRegistered) {
      // If SQLite rejected because email already exists
      return false;
    }

    // 2. Persist in local storage for session & web compatibility
    Map<String, dynamic> users = _getLocalUsers(prefs);
    users[cleanEmail.toLowerCase()] = {
      'name': cleanName,
      'email': cleanEmail,
      'password': cleanPassword,
    };
    await prefs.setString(_registeredUsersKey, jsonEncode(users));

    // Send HTTP sync for Web environment
    sendWebRegister(cleanName, cleanEmail, cleanPassword);

    // Account registered, but require user to log in explicitly
    await prefs.setBool(_isLoggedInKey, false);
    return true;
  }

  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim().replaceAll("'", "");

    // 1. First attempt to check against SQLite users table
    final dbUser = await DbHelper.loginUser(cleanEmail, cleanPassword);
    if (dbUser != null) {
      await prefs.setString(_userNameKey, dbUser['name']?.toString() ?? 'Пайдаланушы');
      await prefs.setString(_userEmailKey, cleanEmail);
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    }

    // 2. Fallback check for local storage / web mode
    Map<String, dynamic> users = _getLocalUsers(prefs);
    for (final entry in users.entries) {
      if (entry.key.toLowerCase() == cleanEmail) {
        final u = entry.value;
        final storedPass = u['password']?.toString().trim().replaceAll("'", "");
        if (storedPass == cleanPassword) {
          await prefs.setString(_userNameKey, u['name']?.toString() ?? 'Пайдаланушы');
          await prefs.setString(_userEmailKey, cleanEmail);
          await prefs.setBool(_isLoggedInKey, true);
          return true;
        }
      }
    }

    // 3. Known accounts fallback (including malika and typo alias mailka)
    final knownAccounts = <String, (String, String)>{
      'aruzhan@mail.kz': ('Аружан', '123456'),
      'student@mail.kz': ('Студент', 'student123'),
      'daniyar@gmail.com': ('Данияр', 'qwerty'),
      'malika@gmail.com': ('malika', '1234'),
      'mailka@gmail.com': ('malika', '1234'),
      'aru@gmail.com': ('aru', '1234'),
      'aru2@gmail.com': ('aru', '1234'),
      'test@gmail.com': ('test', '33456'),
    };

    if (knownAccounts.containsKey(cleanEmail)) {
      final account = knownAccounts[cleanEmail]!;
      if (account.$2 == cleanPassword) {
        await prefs.setString(_userNameKey, account.$1);
        await prefs.setString(_userEmailKey, cleanEmail);
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }
    }

    return false;
  }

  Map<String, dynamic> _getLocalUsers(SharedPreferences prefs) {
    final raw = prefs.getString(_registeredUsersKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }
}
