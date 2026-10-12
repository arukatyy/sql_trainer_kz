class Lesson {
  final int id;
  final String title;
  final String description;
  final String taskDescription;
  final String setupQuery;
  final String expectedQuery;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.taskDescription,
    required this.setupQuery,
    required this.expectedQuery,
  });
}
