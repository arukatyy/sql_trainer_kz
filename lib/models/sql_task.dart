enum Difficulty { beginner, intermediate, advanced }

enum TaskStatus {
  locked,
  notStarted,
  inProgress,
  solved,
  solvedWithHint,
  solutionViewed
}

class SqlTask {
  final int id;
  final String title;
  final String description;
  final Difficulty difficulty;
  final String category;
  final String databaseName;
  final String expectedQuery;
  final List<String> hints;
  final int xp;
  final String taskCondition;
  
  TaskStatus status;

  SqlTask({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.category,
    required this.databaseName,
    required this.expectedQuery,
    required this.hints,
    required this.xp,
    required this.taskCondition,
    this.status = TaskStatus.notStarted,
  });

  factory SqlTask.fromJson(Map<String, dynamic> json) {
    return SqlTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      difficulty: Difficulty.values.firstWhere((e) => e.toString().split('.').last == json['difficulty'], orElse: () => Difficulty.beginner),
      category: json['category'],
      databaseName: json['databaseName'],
      expectedQuery: json['expectedQuery'],
      hints: List<String>.from(json['hints'] ?? []),
      xp: json['xp'],
      taskCondition: json['taskCondition'],
      status: TaskStatus.values.firstWhere((e) => e.toString().split('.').last == json['status'], orElse: () => TaskStatus.notStarted),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty.toString().split('.').last,
      'category': category,
      'databaseName': databaseName,
      'expectedQuery': expectedQuery,
      'hints': hints,
      'xp': xp,
      'taskCondition': taskCondition,
      'status': status.toString().split('.').last,
    };
  }
}
