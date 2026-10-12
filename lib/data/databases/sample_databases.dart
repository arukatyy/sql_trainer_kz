const String sqlTrainerInitScript = '''
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

CREATE TABLE IF NOT EXISTS user_progress (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  task_id INTEGER NOT NULL,
  status TEXT NOT NULL,
  completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS students (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  age INTEGER,
  city TEXT,
  specialty TEXT,
  gpa DECIMAL
);

CREATE TABLE IF NOT EXISTS teachers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  department TEXT
);

CREATE TABLE IF NOT EXISTS courses (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  teacher_id INTEGER
);

CREATE TABLE IF NOT EXISTS grades (
  student_id INTEGER,
  course_id INTEGER,
  grade INTEGER
);

INSERT OR IGNORE INTO users (id, name, email, password, total_xp, streak_days, level) VALUES 
(1, 'Аружан', 'aruzhan@mail.kz', '123456', 240, 5, 2),
(2, 'Данияр', 'daniyar@gmail.com', 'qwerty', 80, 2, 1),
(3, 'Студент', 'student@mail.kz', 'student123', 0, 1, 1);

INSERT OR IGNORE INTO students (id, name, age, city, specialty, gpa) VALUES 
(1, 'Аружан', 17, 'Astana', 'IT', 3.7),
(2, 'Алина', 18, 'Almaty', 'Design', 3.9),
(3, 'Данияр', 19, 'Astana', 'Math', 3.4),
(4, 'Мадина', 20, 'Shymkent', 'IT', 3.8),
(5, 'Санжар', 21, 'Almaty', 'IT', 3.2),
(6, 'Айгерім', 18, 'Astana', 'Design', 3.95),
(7, 'Бауыржан', 22, 'Karaganda', 'Math', 3.1),
(8, 'Дильназ', 19, 'Aktobe', 'IT', 3.65);

INSERT OR IGNORE INTO teachers (id, name, department) VALUES 
(1, 'Иван', 'IT'),
(2, 'Сара', 'Math'),
(3, 'Нұрлан', 'IT'),
(4, 'Айгүл', 'Design');

INSERT OR IGNORE INTO courses (id, name, teacher_id) VALUES 
(1, 'Databases', 1),
(2, 'Calculus', 2),
(3, 'Python Programming', 3),
(4, 'UI/UX Design', 4);

INSERT OR IGNORE INTO grades (student_id, course_id, grade) VALUES 
(1, 1, 95), (2, 1, 88), (3, 2, 75), (4, 1, 100), (5, 3, 82), (6, 4, 91), (7, 2, 68), (8, 1, 85);
''';

final Map<String, String> sampleDatabases = {
  'sql_trainer': sqlTrainerInitScript,
};

final Map<String, String> sqlTrainerSchema = {
  'users': 'id INTEGER, name TEXT, email TEXT, password TEXT, total_xp INTEGER, streak_days INTEGER, level INTEGER',
  'user_progress': 'id INTEGER, user_id INTEGER, task_id INTEGER, status TEXT, completed_at TIMESTAMP',
  'students': 'id INTEGER, name TEXT, age INTEGER, city TEXT, specialty TEXT, gpa DECIMAL',
  'teachers': 'id INTEGER, name TEXT, department TEXT',
  'courses': 'id INTEGER, name TEXT, teacher_id INTEGER',
  'grades': 'student_id INTEGER, course_id INTEGER, grade INTEGER',
};

final Map<String, Map<String, String>> databaseSchemas = {
  'sql_trainer': sqlTrainerSchema,
};
