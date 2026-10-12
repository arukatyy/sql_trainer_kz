import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';

class StorageService {
  static const String _progressKey = 'user_progress';

  Future<UserProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? progressJson = prefs.getString(_progressKey);
    
    if (progressJson != null) {
      try {
        return UserProgress.fromJson(jsonDecode(progressJson));
      } catch (e) {
        return UserProgress();
      }
    }
    return UserProgress();
  }

  Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final String progressJson = jsonEncode(progress.toJson());
    await prefs.setString(_progressKey, progressJson);
  }

  Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
  }
}
