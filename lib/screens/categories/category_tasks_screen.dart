import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/sql_task.dart';
import '../../services/progress_service.dart';
import '../../widgets/task_card.dart';
import '../task/task_screen.dart';

class CategoryTasksScreen extends StatelessWidget {
  final String categoryName;
  final List<SqlTask> tasks;

  const CategoryTasksScreen({
    super.key,
    required this.categoryName,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);

    // Update statuses
    for (var task in tasks) {
      task.status = progressProvider.getTaskStatus(task.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            tooltip: 'Теорияны оқу',
            onPressed: () {
              _showTheoryDialog(context, categoryName);
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskScreen(task: task),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showTheoryDialog(BuildContext context, String category) {
    String theoryText = 'SQL бойынша жалпы теория. Көбірек жаттығыңыз!';
    final catLower = category.toLowerCase();
    if (catLower.contains('select')) {
      theoryText = 'SELECT дерекқордан деректерді таңдап алу үшін қолданылады. Нақты бағандарды таңдауға немесе барлық бағандар үшін * пайдалануға болады. \n\nМысалы: SELECT name, age FROM students;';
    } else if (catLower.contains('where')) {
      theoryText = 'WHERE жолдарды сүзуге мүмкіндік береді. =, <, >, <=, >=, <> операторларын және логикалық AND, OR операторларын қолдануға болады.\n\nМысалы: SELECT * FROM students WHERE age > 18 AND city = "Astana";';
    } else if (catLower.contains('order')) {
      theoryText = 'ORDER BY нәтижені бір немесе бірнеше баған бойынша сұрыптайды.\nASC - өсу ретімен (әдепкі)\nDESC - кему ретімен.\n\nМысалы: ORDER BY price DESC;';
    } else if (catLower.contains('group') || catLower.contains('агрега') || catLower.contains('агрегат')) {
      theoryText = 'Агрегаттық функциялар (COUNT, SUM, AVG, MAX, MIN) бірнеше жолдан бір мән есептейді. \nGROUP BY бірдей мәндері бар жолдарды топтайды.\n\nМысалы: SELECT city, COUNT(*) FROM students GROUP BY city;';
    } else if (catLower.contains('join')) {
      theoryText = 'JOIN екі немесе одан да көп кестені байланысты бағандар негізінде біріктіру үшін қолданылады.\n\nМысалы: SELECT a.name, b.amount FROM employees a JOIN salaries b ON a.id = b.employee_id;';
    } else if (catLower.contains('ішкі') || catLower.contains('подзапрос')) {
      theoryText = 'Ішкі сұраныс (Subquery) - бұл басқа сұраныстың ішінде жазылатын сұраныс. Ол көбінесе WHERE немесе FROM блогында қолданылады.\n\nМысалы: SELECT name FROM employees WHERE id IN (SELECT employee_id FROM salaries WHERE amount > 4000);';
    } else if (catLower.contains('күрделі') || catLower.contains('сложные')) {
      theoryText = 'Күрделі сұраныстар JOIN, GROUP BY, агрегаттық функциялар мен сүзгілерді қатар қолдана отырып, күрделі аналитикалық есептерді шығаруға арналған.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Expanded(child: Text('Теория: $category', style: const TextStyle(color: Colors.white, fontSize: 18))),
          ],
        ),
        content: Text(theoryText, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Түсінікті, тәжірибеге көшейік!'),
          )
        ],
      ),
    );
  }
}
