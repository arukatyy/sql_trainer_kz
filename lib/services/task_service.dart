import '../../models/sql_task.dart';

class TaskService {
  List<SqlTask> get allTasks => _mockTasks;

  List<SqlTask> getTasksByCategory(String category) {
    return _mockTasks.where((t) => t.category == category).toList();
  }
  
  List<SqlTask> getTasksByDifficulty(Difficulty difficulty) {
    return _mockTasks.where((t) => t.difficulty == difficulty).toList();
  }
  
  SqlTask? getTaskById(int id) {
    try {
      return _mockTasks.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  final List<SqlTask> _mockTasks = [
    // ==========================================
    // LEVEL 1: БАСТАУЫШ ДЕҢГЕЙ (20 Тапсырма)
    // ==========================================
    SqlTask(
      id: 1, 
      title: 'Барлық студенттер', 
      description: 'students кестесінен барлық мәліметтерді алыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM students;', 
      hints: ['Барлық бағандарды таңдау үшін * белгісін қолданыңыз'], 
      xp: 10, 
      taskCondition: 'students кестесінен барлық бағандарды шығарыңыз.'
    ),
    SqlTask(
      id: 2, 
      title: 'Студенттердің есімдері', 
      description: 'Тек студенттердің есімдерін алыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT name FROM students;', 
      hints: ['name бағанын көрсетіңіз'], 
      xp: 10, 
      taskCondition: 'Барлық студенттердің есімдерін шығаратын сұраныс жазыңыз.'
    ),
    SqlTask(
      id: 3, 
      title: 'Студенттердің қалалары', 
      description: 'Студенттер келген қалалардың тізімін алыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT city FROM students;', 
      hints: ['city бағаны'], 
      xp: 10, 
      taskCondition: 'Барлық студенттердің қалаларын шығарыңыз.'
    ),
    SqlTask(
      id: 4, 
      title: 'Бірегей мамандықтар', 
      description: 'Қайталанбайтын бірегей мамандықтар тізімін алыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT DISTINCT specialty FROM students;', 
      hints: ['DISTINCT қолданыңыз'], 
      xp: 10, 
      taskCondition: 'specialty бағанының бірегей мәндерін шығарыңыз.'
    ),
    SqlTask(
      id: 5, 
      title: 'Барлық оқытушылар', 
      description: 'teachers кестесінен барлық мәліметтерді шығарыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM teachers;', 
      hints: ['teachers кестесі'], 
      xp: 10, 
      taskCondition: 'teachers кестесінен барлық деректерді алыңыз.'
    ),
    SqlTask(
      id: 6, 
      title: 'Оқытушылардың есімдері', 
      description: 'Тек оқытушылардың есімдерін шығарыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT name FROM teachers;', 
      hints: ['name бағаны'], 
      xp: 10, 
      taskCondition: 'Барлық оқытушылардың есімдерін шығарыңыз.'
    ),
    SqlTask(
      id: 7, 
      title: 'Бірегей кафедралар', 
      description: 'Оқытушылар жұмыс істейтін бірегей кафедралар тізімі.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT DISTINCT department FROM teachers;', 
      hints: ['DISTINCT department қолданыңыз'], 
      xp: 10, 
      taskCondition: 'department бағанының қайталанбайтын мәндерін шығарыңыз.'
    ),
    SqlTask(
      id: 8, 
      title: 'Барлық оқу курстары', 
      description: 'courses кестесінен барлық пәндерді шығарыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM courses;', 
      hints: ['courses кестесі'], 
      xp: 10, 
      taskCondition: 'courses кестесінен барлық жазбаларды шығарыңыз.'
    ),
    SqlTask(
      id: 9, 
      title: 'Курстардың атаулары', 
      description: 'Тек оқу пәндерінің атаулары.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT name FROM courses;', 
      hints: ['courses кестесінен name бағанын алыңыз'], 
      xp: 10, 
      taskCondition: 'Барлық оқу курстарының атауларын алыңыз.'
    ),
    SqlTask(
      id: 10, 
      title: 'Пайдаланушылар пошталары', 
      description: 'Тіркелген қолданушылардың email мекенжайлары.', 
      difficulty: Difficulty.beginner, 
      category: 'SELECT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT email FROM users;', 
      hints: ['users кестесінен email таңдаңыз'], 
      xp: 10, 
      taskCondition: 'users кестесіндегі барлық email мекенжайларды шығарыңыз.'
    ),
    SqlTask(
      id: 11, 
      title: 'Астанадан келген студенттер', 
      description: 'Астана қаласынан келген студенттерді табыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "SELECT * FROM students WHERE city = 'Astana';", 
      hints: ["city = 'Astana'"], 
      xp: 10, 
      taskCondition: 'city өрісі Astana-ға тең болатын студенттерді шығарыңыз.'
    ),
    SqlTask(
      id: 12, 
      title: 'Жасы 18-ден асқандар', 
      description: 'Жасы 18-ден асқан студенттер.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM students WHERE age > 18;', 
      hints: ['age > 18'], 
      xp: 10, 
      taskCondition: 'Жасы қатаң түрде 18-ден үлкен студенттерді табыңыз.'
    ),
    SqlTask(
      id: 13, 
      title: 'IT бөлімінің оқытушылары', 
      description: 'IT кафедрасының оқытушыларын табыңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "SELECT * FROM teachers WHERE department = 'IT';", 
      hints: ["department = 'IT'"], 
      xp: 10, 
      taskCondition: "department өрісі 'IT'-ге тең оқытушыларды шығарыңыз."
    ),
    SqlTask(
      id: 14, 
      title: 'IT мамандығының студенттері', 
      description: 'IT мамандығында оқитын студенттер.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "SELECT * FROM students WHERE specialty = 'IT';", 
      hints: ["specialty = 'IT'"], 
      xp: 10, 
      taskCondition: 'IT мамандығында оқитын студенттерді табыңыз.'
    ),
    SqlTask(
      id: 15, 
      title: 'Жасы 20-дан кіші студенттер', 
      description: 'Жасы 20-дан кіші студенттерді анықтаңыз.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM students WHERE age < 20;', 
      hints: ['age < 20'], 
      xp: 10, 
      taskCondition: 'Жасы 20-ға толмаған студенттерді алыңыз.'
    ),
    SqlTask(
      id: 16, 
      title: 'Үлгерімі жоғары студенттер', 
      description: 'GPA балы 3.5-тен жоғары студенттер.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM students WHERE gpa > 3.5;', 
      hints: ['gpa > 3.5'], 
      xp: 10, 
      taskCondition: 'GPA балы 3.5-тен асатын студенттерді табыңыз.'
    ),
    SqlTask(
      id: 17, 
      title: 'Design мамандығы', 
      description: 'Design саласында оқитын барлық студенттер.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "SELECT * FROM students WHERE specialty = 'Design';", 
      hints: ["specialty = 'Design'"], 
      xp: 10, 
      taskCondition: 'Design мамандығындағы барлық студенттерді табыңыз.'
    ),
    SqlTask(
      id: 18, 
      title: 'Аружанның поштасы', 
      description: 'Аружан есімді қолданушының поштасы.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "SELECT email FROM users WHERE name = 'Аружан';", 
      hints: ["name = 'Аружан'"], 
      xp: 10, 
      taskCondition: 'Аружан пайдаланушысының email мекенжайын алыңыз.'
    ),
    SqlTask(
      id: 19, 
      title: 'Math кафедрасының оқытушылары', 
      description: 'Math кафедрасы оқытушысының id нөмірі.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "SELECT id FROM teachers WHERE department = 'Math';", 
      hints: ["department = 'Math'"], 
      xp: 10, 
      taskCondition: 'Math кафедрасының оқытушысының id нөмірін анықтаңыз.'
    ),
    SqlTask(
      id: 20, 
      title: 'Үздік оқушылар', 
      description: 'GPA көрсеткіші >= 3.8 болатын студенттер.', 
      difficulty: Difficulty.beginner, 
      category: 'WHERE', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT name FROM students WHERE gpa >= 3.8;', 
      hints: ['gpa >= 3.8'], 
      xp: 10, 
      taskCondition: 'Баллы 3.8 және одан жоғары студенттердің есімдерін шығарыңыз.'
    ),

    // ==========================================
    // LEVEL 2: ОРТА ДЕҢГЕЙ (20 Тапсырма)
    // ==========================================
    SqlTask(
      id: 21, 
      title: 'Астанадағы IT студенттері', 
      description: 'Астанадан келген IT мамандығының студенттері.', 
      difficulty: Difficulty.intermediate, 
      category: 'WHERE AND', 
      databaseName: 'sql_trainer', 
      expectedQuery: "SELECT * FROM students WHERE city = 'Astana' AND specialty = 'IT';", 
      hints: ['AND операторын қолданыңыз'], 
      xp: 20, 
      taskCondition: 'city=Astana ЖӘНЕ specialty=IT болатын студенттерді табыңыз.'
    ),
    SqlTask(
      id: 22, 
      title: 'IT немесе Design мамандықтары', 
      description: 'IT немесе Design бағытындағы барлық студенттер.', 
      difficulty: Difficulty.intermediate, 
      category: 'WHERE OR', 
      databaseName: 'sql_trainer', 
      expectedQuery: "SELECT * FROM students WHERE specialty = 'IT' OR specialty = 'Design';", 
      hints: ['OR немесе IN операторын қолданыңыз'], 
      xp: 20, 
      taskCondition: 'IT НЕМЕСЕ Design мамандығындағы студенттерді табыңыз.'
    ),
    SqlTask(
      id: 23, 
      title: 'Студенттерді GPA бойынша сұрыптау', 
      description: 'Жоғары баллдан төменге қарай студенттер.', 
      difficulty: Difficulty.intermediate, 
      category: 'ORDER BY', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM students ORDER BY gpa DESC;', 
      hints: ['ORDER BY gpa DESC'], 
      xp: 20, 
      taskCondition: 'students кестесін gpa бағаны бойынша кему ретімен сұрыптаңыз.'
    ),
    SqlTask(
      id: 24, 
      title: 'Студенттерді жасы бойынша сұрыптау', 
      description: 'Жасы бойынша жастардан үлкендерге қарай.', 
      difficulty: Difficulty.intermediate, 
      category: 'ORDER BY', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM students ORDER BY age ASC;', 
      hints: ['ORDER BY age ASC'], 
      xp: 20, 
      taskCondition: 'Студенттерді жасы бойынша өсу ретімен сұрыптаңыз.'
    ),
    SqlTask(
      id: 25, 
      title: 'Ең жоғары 2 балл (GPA)', 
      description: 'Алғашқы екі үздік студент.', 
      difficulty: Difficulty.intermediate, 
      category: 'LIMIT', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT * FROM students ORDER BY gpa DESC LIMIT 2;', 
      hints: ['LIMIT 2'], 
      xp: 20, 
      taskCondition: 'students кестесінен GPA-сы ең жоғары 2 студентті алыңыз.'
    ),
    SqlTask(
      id: 26, 
      title: 'Студенттер саны', 
      description: 'Барлығы қанша студент бар?', 
      difficulty: Difficulty.intermediate, 
      category: 'Агрегация', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT COUNT(*) FROM students;', 
      hints: ['COUNT(*) функциясы'], 
      xp: 20, 
      taskCondition: 'Студенттердің жалпы санын есептеңіз.'
    ),
    SqlTask(
      id: 27, 
      title: 'Орташа балл (GPA)', 
      description: 'Колледж бойынша орташа балл.', 
      difficulty: Difficulty.intermediate, 
      category: 'Агрегация', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT AVG(gpa) FROM students;', 
      hints: ['AVG(gpa) функциясы'], 
      xp: 20, 
      taskCondition: 'Барлық студенттердің GPA орташа мәнін есептеңіз.'
    ),
    SqlTask(
      id: 28, 
      title: 'Барлық бағалардың қосындысы', 
      description: 'grades кестесіндегі барлық бағалардың сомасы.', 
      difficulty: Difficulty.intermediate, 
      category: 'Агрегация', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT SUM(grade) FROM grades;', 
      hints: ['SUM(grade) функциясы'], 
      xp: 20, 
      taskCondition: 'grades кестесіндегі барлық бағалардың жалпы сомасын табыңыз.'
    ),
    SqlTask(
      id: 29, 
      title: 'Ең жоғары GPA', 
      description: 'Ең үздік GPA бағасы.', 
      difficulty: Difficulty.intermediate, 
      category: 'Агрегация', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT MAX(gpa) FROM students;', 
      hints: ['MAX(gpa) функциясы'], 
      xp: 20, 
      taskCondition: 'Студенттер арасындағы ең жоғары GPA көрсеткішін табыңыз.'
    ),
    SqlTask(
      id: 30, 
      title: 'Ең кіші жас', 
      description: 'Ең жас студенттің жасы.', 
      difficulty: Difficulty.intermediate, 
      category: 'Агрегация', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT MIN(age) FROM students;', 
      hints: ['MIN(age) функциясы'], 
      xp: 20, 
      taskCondition: 'Студенттер арасындағы ең кіші жасты табыңыз.'
    ),
    SqlTask(
      id: 31, 
      title: 'Мамандықтар бойынша студенттер саны', 
      description: 'Әр мамандықта қанша студент бар?', 
      difficulty: Difficulty.intermediate, 
      category: 'GROUP BY', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT specialty, COUNT(*) FROM students GROUP BY specialty;', 
      hints: ['GROUP BY specialty', 'COUNT(*)'], 
      xp: 20, 
      taskCondition: 'Студенттерді specialty бойынша топтап, әр топтағы санын шығарыңыз.'
    ),
    SqlTask(
      id: 32, 
      title: 'Қалалар бойынша студенттер', 
      description: 'Әр қаладан қанша студент бар?', 
      difficulty: Difficulty.intermediate, 
      category: 'GROUP BY', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT city, COUNT(*) FROM students GROUP BY city;', 
      hints: ['GROUP BY city'], 
      xp: 20, 
      taskCondition: 'Қаланы және сол қаладан келген студенттер санын шығарыңыз.'
    ),
    SqlTask(
      id: 33, 
      title: 'Пәндер бойынша орташа баға', 
      description: 'grades кестесіндегі пәндердің орташа бағасы.', 
      difficulty: Difficulty.intermediate, 
      category: 'GROUP BY', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT course_id, AVG(grade) FROM grades GROUP BY course_id;', 
      hints: ['GROUP BY course_id'], 
      xp: 20, 
      taskCondition: 'grades кестесін course_id бойынша топтап, AVG(grade) табыңыз.'
    ),
    SqlTask(
      id: 34, 
      title: 'Студенттердің бағалар саны', 
      description: 'Әр студенттің қанша бағасы бар?', 
      difficulty: Difficulty.intermediate, 
      category: 'GROUP BY', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT student_id, COUNT(*) FROM grades GROUP BY student_id;', 
      hints: ['GROUP BY student_id'], 
      xp: 20, 
      taskCondition: 'Бағаларды student_id бойынша топтап, олардың санын есептеңіз.'
    ),
    SqlTask(
      id: 35, 
      title: 'Қаланы өзгерту', 
      description: 'Алина атты студент Astana-ға көшті.', 
      difficulty: Difficulty.intermediate, 
      category: 'UPDATE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "UPDATE students SET city = 'Astana' WHERE name = 'Алина';", 
      hints: ['UPDATE students SET ...'], 
      xp: 20, 
      taskCondition: 'Алина есімді студенттің city өрісін Astana-ға жаңартыңыз.'
    ),
    SqlTask(
      id: 36, 
      title: 'GPA балын жаңарту', 
      description: 'Аружанның GPA балын 3.9-ға көтеріңіз.', 
      difficulty: Difficulty.intermediate, 
      category: 'UPDATE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "UPDATE students SET gpa = 3.9 WHERE name = 'Аружан';", 
      hints: ['UPDATE students SET gpa = 3.9 WHERE name = ...'], 
      xp: 20, 
      taskCondition: "Аружан атты студенттің gpa көрсеткішін 3.9-ға жаңартыңыз."
    ),
    SqlTask(
      id: 37, 
      title: 'Бағаны жою', 
      description: 'student_id 3 және course_id 2 болатын бағаны өшіріңіз.', 
      difficulty: Difficulty.intermediate, 
      category: 'DELETE', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'DELETE FROM grades WHERE student_id = 3 AND course_id = 2;', 
      hints: ['DELETE FROM grades WHERE ...'], 
      xp: 20, 
      taskCondition: 'grades кестесінен student_id 3 және course_id 2 болатын жазбаны жойыңыз.'
    ),
    SqlTask(
      id: 38, 
      title: 'Жаңа студент қосу', 
      description: 'Тимур атты студентті қосыңыз (id=9, age=18).', 
      difficulty: Difficulty.intermediate, 
      category: 'INSERT', 
      databaseName: 'sql_trainer', 
      expectedQuery: "INSERT INTO students (id, name, age, city, specialty, gpa) VALUES (9, 'Тимур', 18, 'Almaty', 'IT', 3.5);", 
      hints: ['INSERT INTO students (...) VALUES (...)'], 
      xp: 20, 
      taskCondition: 'Параметрлері: id 9, name Тимур, age 18, city Almaty, specialty IT, gpa 3.5 болатын жаңа жазба енгізіңіз.'
    ),
    SqlTask(
      id: 39, 
      title: 'Студентті өшіру', 
      description: 'id 4 болатын студентті базадан өшіріңіз.', 
      difficulty: Difficulty.intermediate, 
      category: 'DELETE', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'DELETE FROM students WHERE id = 4;', 
      hints: ['DELETE FROM students WHERE id = 4'], 
      xp: 20, 
      taskCondition: 'students кестесінен id = 4 болатын жазбаны жойыңыз.'
    ),
    SqlTask(
      id: 40, 
      title: 'Бағаларға үстеме қосу', 
      description: '1-пәннің барлық бағаларына 5 балл қосыңыз.', 
      difficulty: Difficulty.intermediate, 
      category: 'UPDATE', 
      databaseName: 'sql_trainer', 
      expectedQuery: "UPDATE grades SET grade = grade + 5 WHERE course_id = 1;", 
      hints: ['UPDATE grades SET grade = grade + 5 WHERE course_id = 1'], 
      xp: 20, 
      taskCondition: 'grades кестесіндегі course_id = 1 үшін grade-ке 5 балл қосыңыз.'
    ),

    // ==========================================
    // LEVEL 3: ЖОҒАРЫ ДЕҢГЕЙ (15 Тапсырма)
    // ==========================================
    SqlTask(
      id: 41, 
      title: 'Оқытушылар және олардың курстары', 
      description: 'Оқытушылар мен олардың пәндерінің атауы.', 
      difficulty: Difficulty.advanced, 
      category: 'JOIN', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT teachers.name, courses.name FROM teachers JOIN courses ON teachers.id = courses.teacher_id;', 
      hints: ['JOIN courses ON teachers.id = courses.teacher_id'], 
      xp: 30, 
      taskCondition: 'teachers пен courses кестелерін біріктіріп, оқытушы аты мен курс атауын шығарыңыз.'
    ),
    SqlTask(
      id: 42, 
      title: 'Студенттер және олардың бағалары', 
      description: 'Студенттің аты және оның бағасы.', 
      difficulty: Difficulty.advanced, 
      category: 'JOIN', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT students.name, grades.grade FROM students JOIN grades ON students.id = grades.student_id;', 
      hints: ['JOIN grades ON students.id = grades.student_id'], 
      xp: 30, 
      taskCondition: 'students пен grades кестелерін JOIN жасаңыз.'
    ),
    SqlTask(
      id: 43, 
      title: 'Студенттер және курстар', 
      description: 'Студенттің аты және оқитын курсының атауы.', 
      difficulty: Difficulty.advanced, 
      category: 'JOIN', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT students.name, courses.name FROM students JOIN grades ON students.id = grades.student_id JOIN courses ON grades.course_id = courses.id;', 
      hints: ['students, grades және courses кестелерін біріктіріңіз'], 
      xp: 30, 
      taskCondition: 'Студенттің есімі мен ол оқитын пәннің атауын байланыстырып шығарыңыз.'
    ),
    SqlTask(
      id: 44, 
      title: 'Үздік баға алған студенттер (> 90)', 
      description: 'Студент есімі және бағасы > 90.', 
      difficulty: Difficulty.advanced, 
      category: 'JOIN', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT students.name, grades.grade FROM students JOIN grades ON students.id = grades.student_id WHERE grades.grade > 90;', 
      hints: ['JOIN grades ... WHERE grade > 90'], 
      xp: 30, 
      taskCondition: 'Бағасы 90-нан жоғары болған жағдайда ғана студент аты мен бағасын шығарыңыз.'
    ),
    SqlTask(
      id: 45, 
      title: 'Databases курсындағы студенттер', 
      description: '1-курстағы (Databases) студенттердің есімдері.', 
      difficulty: Difficulty.advanced, 
      category: 'JOIN', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT students.name FROM students JOIN grades ON students.id = grades.student_id WHERE grades.course_id = 1;', 
      hints: ['JOIN grades', 'WHERE course_id = 1'], 
      xp: 30, 
      taskCondition: 'course_id = 1 бойынша бағалары бар студенттердің есімдерін алыңыз.'
    ),
    SqlTask(
      id: 46, 
      title: 'Оқытушылардың кафедрасы мен курстары', 
      description: 'Оқытушы аты, оның кафедрасы және курсы.', 
      difficulty: Difficulty.advanced, 
      category: 'JOIN', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT teachers.name, teachers.department, courses.name FROM teachers JOIN courses ON teachers.id = courses.teacher_id;', 
      hints: ['JOIN courses ON teachers.id = courses.teacher_id'], 
      xp: 30, 
      taskCondition: 'teachers пен courses кестелерін біріктіріп, оқытушы аты, кафедрасы мен пәнін шығарыңыз.'
    ),
    SqlTask(
      id: 47, 
      title: 'Кім 85-тен көп балл алды?', 
      description: 'Бағасы 85-тен жоғары студенттердің есімдері.', 
      difficulty: Difficulty.advanced, 
      category: 'Ішкі сұраныстар', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT name FROM students WHERE id IN (SELECT student_id FROM grades WHERE grade > 85);', 
      hints: ['WHERE id IN (SELECT ...) қолданыңыз'], 
      xp: 40, 
      taskCondition: 'Ішкі сұранысты пайдаланып, бағасы > 85 болатын студенттердің есімдерін шығарыңыз.'
    ),
    SqlTask(
      id: 48, 
      title: 'Орташадан жоғары студенттер', 
      description: 'GPA көрсеткіші орташадан жоғары студенттер.', 
      difficulty: Difficulty.advanced, 
      category: 'Ішкі сұраныстар', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT name FROM students WHERE gpa > (SELECT AVG(gpa) FROM students);', 
      hints: ['WHERE gpa > (SELECT AVG(gpa) ...)'], 
      xp: 40, 
      taskCondition: 'GPA көрсеткіші барлық студенттердің орташа GPA-сынан жоғары студенттердің есімдерін шығарыңыз.'
    ),
    SqlTask(
      id: 49, 
      title: 'Орташа бағадан жоғары бағалар', 
      description: 'Орташа бағадан жоғары баға алған студенттердің id нөмірлері.', 
      difficulty: Difficulty.advanced, 
      category: 'Ішкі сұраныстар', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT student_id FROM grades WHERE grade > (SELECT AVG(grade) FROM grades);', 
      hints: ['WHERE grade > (SELECT AVG(grade) ...)'], 
      xp: 40, 
      taskCondition: 'Бағасы барлық бағалардың орташа мәнінен жоғары студенттердің student_id өрістерін шығарыңыз.'
    ),
    SqlTask(
      id: 50, 
      title: '1-ден көп студенті бар қалалар', 
      description: 'Бірнеше студент тұратын қалалар.', 
      difficulty: Difficulty.advanced, 
      category: 'HAVING', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT city FROM students GROUP BY city HAVING COUNT(*) > 1;', 
      hints: ['GROUP BY city HAVING COUNT(*) > 1'], 
      xp: 40, 
      taskCondition: 'Қала бойынша топтап, студенттер саны 1-ден көп қалаларды ғана қалдырыңыз (HAVING қолданыңыз).'
    ),
    SqlTask(
      id: 51, 
      title: 'Жоғары бағалы курстар', 
      description: 'Орташа бағасы > 80 болатын курстардың id-і.', 
      difficulty: Difficulty.advanced, 
      category: 'HAVING', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT course_id FROM grades GROUP BY course_id HAVING AVG(grade) > 80;', 
      hints: ['GROUP BY course_id', 'HAVING AVG(grade) > 80'], 
      xp: 40, 
      taskCondition: 'Орташа бағасы 80-нен жоғары болатын course_id нөмірлерін шығарыңыз.'
    ),
    SqlTask(
      id: 52, 
      title: 'Студенттің орташа бағасы', 
      description: 'Студент аты және оның барлық бағаларының орташа мәні.', 
      difficulty: Difficulty.advanced, 
      category: 'Күрделі сұраныстар', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT students.name, AVG(grades.grade) FROM students JOIN grades ON students.id = grades.student_id GROUP BY students.name;', 
      hints: ['JOIN', 'GROUP BY students.name', 'AVG()'], 
      xp: 50, 
      taskCondition: 'Студенттің атын және оның барлық бағаларының орташа көрсеткішін шығарыңыз.'
    ),
    SqlTask(
      id: 53, 
      title: 'Пәндер бойынша үздіктер', 
      description: 'Студент аты, курс атауы және баға > 90.', 
      difficulty: Difficulty.advanced, 
      category: 'Күрделі сұраныстар', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT students.name, courses.name, grades.grade FROM students JOIN grades ON students.id = grades.student_id JOIN courses ON grades.course_id = courses.id WHERE grades.grade > 90;', 
      hints: ['Екі JOIN қажет'], 
      xp: 50, 
      taskCondition: 'Бағасы 90-нан жоғары болған жағдайда студент атын, курс атауын және бағасын шығарыңыз.'
    ),
    SqlTask(
      id: 54, 
      title: 'Кафедралар бойынша оқытушылар саны', 
      description: 'Әр кафедрада қанша оқытушы жұмыс істейтінін есептеңіз.', 
      difficulty: Difficulty.advanced, 
      category: 'Күрделі сұраныстар', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT department, COUNT(*) FROM teachers GROUP BY department;', 
      hints: ['GROUP BY department', 'COUNT(*)'], 
      xp: 50, 
      taskCondition: 'teachers кестесін department бойынша топтап, оқытушылар санын шығарыңыз.'
    ),
    SqlTask(
      id: 55, 
      title: 'Студенттің ең жоғары бағасы', 
      description: 'Студент аты және оның максималды бағасы.', 
      difficulty: Difficulty.advanced, 
      category: 'Күрделі сұраныстар', 
      databaseName: 'sql_trainer', 
      expectedQuery: 'SELECT students.name, MAX(grades.grade) FROM students JOIN grades ON students.id = grades.student_id GROUP BY students.name;', 
      hints: ['JOIN', 'GROUP BY students.name', 'MAX()'], 
      xp: 50, 
      taskCondition: 'Әр студенттің атын және оның барлық бағалары арасындағы ең жоғары балын (MAX) табыңыз.'
    ),
  ];
}
