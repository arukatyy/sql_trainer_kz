import 'package:flutter/foundation.dart';
import '../models/user_progress.dart';
import '../models/sql_task.dart';
import 'storage_service.dart';

class ProgressProvider extends ChangeNotifier {
  final StorageService _storageService;
  UserProgress _progress = UserProgress();
  
  ProgressProvider(this._storageService) {
    _loadInitialProgress();
  }

  UserProgress get progress => _progress;

  Future<void> _loadInitialProgress() async {
    _progress = await _storageService.loadProgress();
    
    // Check daily streak
    final now = DateTime.now();
    if (_progress.lastPlayed != null) {
      final diff = now.difference(_progress.lastPlayed!).inDays;
      if (diff == 1) {
        _progress.streakDays++;
      } else if (diff > 1) {
        _progress.streakDays = 0;
      }
    } else {
      _progress.streakDays = 1;
    }
    _progress.lastPlayed = now;
    await _storageService.saveProgress(_progress);
    notifyListeners();
  }

  Future<void> updateTaskStatus(int taskId, TaskStatus status, int xpGained) async {
    final oldStatusStr = _progress.taskStatuses[taskId];
    TaskStatus oldStatus = TaskStatus.notStarted;
    if (oldStatusStr != null) {
       oldStatus = TaskStatus.values.firstWhere((e) => e.toString().split('.').last == oldStatusStr, orElse: () => TaskStatus.notStarted);
    }

    // Only add xp if transitioning to a solved state from a non-solved state
    if (oldStatus != TaskStatus.solved && oldStatus != TaskStatus.solvedWithHint && oldStatus != TaskStatus.solutionViewed) {
      _progress.totalXp += xpGained;
    }
    
    _progress.taskStatuses[taskId] = status.toString().split('.').last;
    await _storageService.saveProgress(_progress);
    notifyListeners();
  }

  TaskStatus getTaskStatus(int taskId) {
    final statusStr = _progress.taskStatuses[taskId];
    if (statusStr == null) return TaskStatus.notStarted;
    return TaskStatus.values.firstWhere((e) => e.toString().split('.').last == statusStr, orElse: () => TaskStatus.notStarted);
  }

  Future<void> resetProgress() async {
    await _storageService.clearProgress();
    _progress = UserProgress();
    _progress.lastPlayed = DateTime.now();
    _progress.streakDays = 1;
    await _storageService.saveProgress(_progress);
    notifyListeners();
  }
}
