import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/task_service.dart';
import '../../services/progress_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/sql_task.dart';
import 'category_tasks_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = TaskService();
    final allTasks = taskService.allTasks;
    
    // Extract unique categories
    final categories = allTasks.map((t) => t.category).toSet().toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Санаттар мен курстар'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryTasks = allTasks.where((t) => t.category == category).toList();
          return _CategoryCard(
            categoryName: category,
            tasks: categoryTasks,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryTasksScreen(
                    categoryName: category,
                    tasks: categoryTasks,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String categoryName;
  final List<SqlTask> tasks;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.categoryName,
    required this.tasks,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    
    int solvedCount = 0;
    for (var task in tasks) {
      final status = progressProvider.getTaskStatus(task.id);
      if (status == TaskStatus.solved || status == TaskStatus.solvedWithHint) {
        solvedCount++;
      }
    }
    
    final progress = tasks.isNotEmpty ? solvedCount / tasks.length : 0.0;
    
    IconData icon;
    if (categoryName.toLowerCase().contains('select')) {
      icon = Icons.search;
    } else if (categoryName.toLowerCase().contains('where')) {
      icon = Icons.filter_alt;
    } else if (categoryName.toLowerCase().contains('order')) {
      icon = Icons.sort;
    } else if (categoryName.toLowerCase().contains('group')) {
      icon = Icons.grid_view;
    } else if (categoryName.toLowerCase().contains('join')) {
      icon = Icons.compare_arrows;
    } else {
      icon = Icons.library_books;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withAlpha(80), width: 1.5),
                      ),
                      child: Icon(icon, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$solvedCount / ${tasks.length} тапсырма шешілді',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.white54 : Colors.grey.shade400,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark ? Colors.white.withAlpha(20) : Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
