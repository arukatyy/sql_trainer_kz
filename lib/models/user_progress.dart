
class UserProgress {
  int totalXp;
  int streakDays;
  DateTime? lastPlayed;
  Map<int, String> taskStatuses; // Task ID to Status string
  List<String> unlockedAchievements;

  UserProgress({
    this.totalXp = 0,
    this.streakDays = 0,
    this.lastPlayed,
    Map<int, String>? taskStatuses,
    List<String>? unlockedAchievements,
  })  : taskStatuses = taskStatuses ?? {},
        unlockedAchievements = unlockedAchievements ?? [];

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalXp: json['totalXp'] ?? 0,
      streakDays: json['streakDays'] ?? 0,
      lastPlayed: json['lastPlayed'] != null ? DateTime.parse(json['lastPlayed']) : null,
      taskStatuses: (json['taskStatuses'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(int.parse(k), v.toString()),
          ) ?? {},
      unlockedAchievements: List<String>.from(json['unlockedAchievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalXp': totalXp,
      'streakDays': streakDays,
      'lastPlayed': lastPlayed?.toIso8601String(),
      'taskStatuses': taskStatuses.map((k, v) => MapEntry(k.toString(), v)),
      'unlockedAchievements': unlockedAchievements,
    };
  }

  int get level {
    if (totalXp < 100) return 1;
    if (totalXp < 300) return 2;
    if (totalXp < 600) return 3;
    if (totalXp < 1000) return 4;
    if (totalXp < 1500) return 5;
    return 6;
  }
  
  String get levelName {
    switch (level) {
      case 1: return "Бастаушы";
      case 2: return "SQL Студенті";
      case 3: return "SQL Үйренушісі";
      case 4: return "SQL Әзірлеушісі";
      case 5: return "SQL Сарапшысы";
      case 6: return "SQL Шебері";
      default: return "Бастаушы";
    }
  }
}
