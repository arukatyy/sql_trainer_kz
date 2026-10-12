import '../models/lesson.dart';

final List<Lesson> lessonsData = [
  Lesson(
    id: 1,
    title: "1-сабақ: Барлық деректерді алу (SELECT)",
    description: "Деректер қорынан мәліметтерді оқу үшін SELECT командасы қолданылады.\n\nМысалы:\nSELECT * FROM users;\nБұл сұраныс 'users' кестесіндегі барлық бағандар мен қатарларды қайтарады. '*' белгісі барлық бағандар дегенді білдіреді.",
    taskDescription: "'students' кестесінен барлық деректерді алыңыз.",
    setupQuery: "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, age INTEGER); INSERT INTO students (name, age) VALUES ('Асан', 20), ('Үсен', 22), ('Айман', 19);",
    expectedQuery: "SELECT * FROM students;",
  ),
  Lesson(
    id: 2,
    title: "2-сабақ: Деректерді сүзу (WHERE)",
    description: "Белгілі бір шарттарға сәйкес келетін деректерді ғана алу үшін WHERE операторы қолданылады.\n\nМысалы:\nSELECT * FROM users WHERE age > 18;",
    taskDescription: "'students' кестесінен жасы 20-дан үлкен студенттерді табыңыз.",
    setupQuery: "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, age INTEGER); INSERT INTO students (name, age) VALUES ('Асан', 20), ('Үсен', 22), ('Айман', 19), ('Шолпан', 21);",
    expectedQuery: "SELECT * FROM students WHERE age > 20;",
  ),
  Lesson(
    id: 3,
    title: "3-сабақ: Сұрыптау (ORDER BY)",
    description: "Нәтижелерді белгілі бір баған бойынша өсу (ASC) немесе кему (DESC) ретімен сұрыптау үшін ORDER BY қолданылады.\n\nМысалы:\nSELECT * FROM users ORDER BY age DESC;",
    taskDescription: "'students' кестесіндегі студенттерді жасы бойынша кему ретімен сұрыптап шығарыңыз.",
    setupQuery: "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, age INTEGER); INSERT INTO students (name, age) VALUES ('Асан', 20), ('Үсен', 22), ('Айман', 19);",
    expectedQuery: "SELECT * FROM students ORDER BY age DESC;",
  ),
  Lesson(
    id: 4,
    title: "4-сабақ: Деректер қосу (INSERT)",
    description: "Кестеге жаңа жол (қатар) қосу үшін INSERT INTO командасы қолданылады.\n\nМысалы:\nINSERT INTO users (name, age) VALUES ('Қайрат', 25);",
    taskDescription: "'students' кестесіне аты 'Мақсат', жасы 23 болатын жаңа студент қосыңыз. Содан соң барлық студенттерді көрсетіңіз (SELECT * FROM students).",
    setupQuery: "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, age INTEGER); INSERT INTO students (name, age) VALUES ('Асан', 20);",
    expectedQuery: "INSERT INTO students (name, age) VALUES ('Мақсат', 23);\nSELECT * FROM students;",
  ),
  Lesson(
    id: 5,
    title: "5-сабақ: Деректерді жаңарту (UPDATE)",
    description: "Кестедегі бар деректерді өзгерту үшін UPDATE командасы қолданылады. Қай жолды өзгерту керектігін көрсету үшін WHERE міндетті түрде қосылуы керек.\n\nМысалы:\nUPDATE users SET age = 26 WHERE name = 'Қайрат';",
    taskDescription: "'students' кестесіндегі 'Асан' атты студенттің жасын 21-ге өзгертіңіз. Сосын барлық студенттерді шығарыңыз.",
    setupQuery: "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, age INTEGER); INSERT INTO students (name, age) VALUES ('Асан', 20), ('Үсен', 22);",
    expectedQuery: "UPDATE students SET age = 21 WHERE name = 'Асан';\nSELECT * FROM students;",
  ),
];
