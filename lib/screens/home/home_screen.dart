import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/progress_service.dart';
import '../../services/task_service.dart';
import '../../models/sql_task.dart';
import '../task/task_screen.dart';
import '../categories/category_tasks_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/tactile_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final Set<String> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    // By default expand the first category
    final allTasks = _taskService.allTasks;
    if (allTasks.isNotEmpty) {
      _expandedCategories.add(allTasks.first.category);
    }
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains('SELECT')) return Icons.storage_rounded;
    if (category.contains('WHERE')) return Icons.filter_alt_rounded;
    if (category.contains('ORDER') || category.contains('Сұрыптау')) return Icons.sort_rounded;
    if (category.contains('Агрегация') || category.contains('GROUP')) return Icons.calculate_rounded;
    if (category.contains('JOIN')) return Icons.join_inner_rounded;
    if (category.contains('Ішкі')) return Icons.layers_rounded;
    return Icons.auto_awesome_rounded;
  }

  Color _getCategoryColor(int index) {
    const colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.warning,
      AppColors.purple,
      AppColors.pink,
      Color(0xFF0D9488),
      Color(0xFFD97706),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    final allTasks = _taskService.allTasks;

    // Determine furthest solved index
    int furthestSolvedIndex = -1;
    for (int i = 0; i < allTasks.length; i++) {
      allTasks[i].status = progressProvider.getTaskStatus(allTasks[i].id);
      if (allTasks[i].status == TaskStatus.solved ||
          allTasks[i].status == TaskStatus.solvedWithHint ||
          allTasks[i].status == TaskStatus.solutionViewed) {
        furthestSolvedIndex = i;
      }
    }

    final int nextTaskIndex = (furthestSolvedIndex + 1 < allTasks.length)
        ? furthestSolvedIndex + 1
        : allTasks.length - 1;
    final SqlTask currentTask = allTasks[nextTaskIndex];

    // Group tasks by category
    final List<String> categories = [];
    final Map<String, List<SqlTask>> tasksByCategory = {};
    for (var task in allTasks) {
      if (!categories.contains(task.category)) {
        categories.add(task.category);
        tasksByCategory[task.category] = [];
      }
      tasksByCategory[task.category]!.add(task);
    }

    // Auto-expand category of current task
    if (!_expandedCategories.contains(currentTask.category)) {
      _expandedCategories.add(currentTask.category);
    }

    final progress = progressProvider.progress;
    final solvedCount = progress.taskStatuses.values
        .where((s) => s.contains('solved') || s.contains('solutionViewed'))
        .length;
    final totalProgressPercent = allTasks.isEmpty ? 0.0 : (solvedCount / allTasks.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL Тренажері'),
        actions: [
          _buildPillBadge(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.warning,
            text: '${progress.streakDays}',
            tooltip: 'Үздіксіз күндер',
          ),
          const SizedBox(width: 8),
          _buildPillBadge(
            icon: Icons.bolt_rounded,
            iconColor: AppColors.xp,
            text: '${progress.totalXp}',
            tooltip: 'Жинаған XP',
          ),
          const SizedBox(width: 8),
          _buildPillBadge(
            icon: Icons.emoji_events_rounded,
            iconColor: AppColors.success,
            text: '$solvedCount/${allTasks.length}',
            tooltip: 'Шешілген тапсырмалар',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Card: Continue Learning
            _buildHeroContinueCard(
              context: context,
              currentTask: currentTask,
              solvedCount: solvedCount,
              totalTasks: allTasks.length,
              progressPercent: totalProgressPercent,
            ),

            const SizedBox(height: 24),

            // Modules Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Оқу модульдері',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    letterSpacing: -0.3,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${categories.length} Модуль',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // List of Modules (LeetCode / Stepik style)
            ...categories.asMap().entries.map((entry) {
              final catIndex = entry.key;
              final catName = entry.value;
              final catTasks = tasksByCategory[catName]!;
              final isExpanded = _expandedCategories.contains(catName);
              final moduleColor = _getCategoryColor(catIndex);
              final moduleSolved = catTasks
                  .where((t) =>
                      t.status == TaskStatus.solved ||
                      t.status == TaskStatus.solvedWithHint ||
                      t.status == TaskStatus.solutionViewed)
                  .length;

              return _buildModuleCard(
                context: context,
                index: catIndex,
                categoryName: catName,
                tasks: catTasks,
                allTasks: allTasks,
                nextTaskIndex: nextTaskIndex,
                moduleColor: moduleColor,
                solvedCount: moduleSolved,
                isExpanded: isExpanded,
                onToggleExpand: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedCategories.remove(catName);
                    } else {
                      _expandedCategories.add(catName);
                    }
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPillBadge({
    required IconData icon,
    required Color iconColor,
    required String text,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkCardBorder
                : AppColors.lightCardBorder,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroContinueCard({
    required BuildContext context,
    required SqlTask currentTask,
    required int solvedCount,
    required int totalTasks,
    required double progressPercent,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5856D6),
            Color(0xFF3B82F6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withAlpha(80),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative shapes
          Positioned(
            right: -20,
            bottom: -30,
            child: Icon(
              Icons.bolt_rounded,
              size: 160,
              color: Colors.white.withAlpha(20),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top badge row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'КЕЛЕСІ ТАПСЫРМА',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${currentTask.xp} XP',
                      style: const TextStyle(
                        color: AppColors.xp,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Task Title
                Text(
                  'Тапсырма №${currentTask.id}: ${currentTask.title}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 6),

                // Category & condition excerpt
                Text(
                  '${currentTask.category} • ${currentTask.description}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withAlpha(210),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                // Overall progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Жалпы курс бойынша: ${(progressPercent * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.white.withAlpha(220),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '$solvedCount / $totalTasks тапсырма',
                          style: TextStyle(
                            color: Colors.white.withAlpha(220),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        minHeight: 8,
                        backgroundColor: Colors.white.withAlpha(40),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.xp),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Duolingo 2.0 Tactile Start Button
                TactileButton(
                  color: AppColors.success,
                  shadowColor: AppColors.successShadow,
                  borderRadius: 16,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskScreen(task: currentTask)),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Жалғастыру',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required BuildContext context,
    required int index,
    required String categoryName,
    required List<SqlTask> tasks,
    required List<SqlTask> allTasks,
    required int nextTaskIndex,
    required Color moduleColor,
    required int solvedCount,
    required bool isExpanded,
    required VoidCallback onToggleExpand,
  }) {
    final double modulePercent = tasks.isEmpty ? 0.0 : (solvedCount / tasks.length);
    final bool isCompleted = solvedCount == tasks.length && tasks.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkCardBorder
              : AppColors.lightCardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Module Header
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(20),
              bottom: isExpanded ? Radius.zero : const Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: moduleColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: moduleColor.withAlpha(100), width: 1.5),
                    ),
                    child: Icon(
                      _getCategoryIcon(categoryName),
                      color: moduleColor,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Module Title & Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${index + 1}-модуль',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: moduleColor,
                              ),
                            ),
                            if (isCompleted) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: modulePercent,
                                  minHeight: 6,
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withAlpha(20)
                                      : Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isCompleted ? AppColors.success : moduleColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$solvedCount/${tasks.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Expand/Collapse Chevron
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Task List & Theory Shortcut
          if (isExpanded) ...[
            const Divider(height: 1),

            // Theory button banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: moduleColor.withAlpha(15),
              child: Row(
                children: [
                  Icon(Icons.menu_book_rounded, color: moduleColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$categoryName теориясы мен мысалдары',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryTasksScreen(
                            categoryName: categoryName,
                            tasks: tasks,
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      foregroundColor: moduleColor,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    child: const Text('Теория →'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Tasks List inside module
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              separatorBuilder: (context, _) => const SizedBox(height: 8),
              itemBuilder: (context, taskIndex) {
                final task = tasks[taskIndex];
                final globalIndex = allTasks.indexOf(task);
                final isLocked = globalIndex > nextTaskIndex;
                final isNext = globalIndex == nextTaskIndex;

                return _buildTaskItem(
                  context: context,
                  task: task,
                  isLocked: isLocked,
                  isNext: isNext,
                  moduleColor: moduleColor,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskItem({
    required BuildContext context,
    required SqlTask task,
    required bool isLocked,
    required bool isNext,
    required Color moduleColor,
  }) {
    final bool isSolved = task.status == TaskStatus.solved;
    final bool isSolvedWithHint = task.status == TaskStatus.solvedWithHint;
    final bool isSolutionViewed = task.status == TaskStatus.solutionViewed;
    final bool isDone = isSolved || isSolvedWithHint || isSolutionViewed;

    Color badgeColor;
    String badgeText;
    switch (task.difficulty) {
      case Difficulty.beginner:
        badgeColor = AppColors.success;
        badgeText = 'БАСТАУШЫ';
        break;
      case Difficulty.intermediate:
        badgeColor = AppColors.warning;
        badgeText = 'ОРТАША';
        break;
      case Difficulty.advanced:
        badgeColor = AppColors.error;
        badgeText = 'ЖОҒАРЫ';
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Алдымен алдыңғы тапсырмаларды шешіңіз!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskScreen(task: task)),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isNext
                ? moduleColor.withAlpha(20)
                : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withAlpha(5)
                    : Colors.grey.shade50),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isNext
                  ? moduleColor
                  : (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkCardBorder
                      : AppColors.lightCardBorder),
              width: isNext ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Status Circle / Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? AppColors.success.withAlpha(30)
                      : (isNext
                          ? moduleColor
                          : (isLocked
                              ? Colors.grey.withAlpha(30)
                              : moduleColor.withAlpha(20))),
                  border: Border.all(
                    color: isDone
                        ? AppColors.success
                        : (isNext
                            ? moduleColor
                            : (isLocked ? Colors.grey.shade400 : moduleColor)),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check_rounded, color: AppColors.success, size: 20)
                      : (isNext
                          ? const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22)
                          : (isLocked
                              ? const Icon(Icons.lock_rounded, color: Colors.grey, size: 16)
                              : Text(
                                  '${task.id}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: moduleColor,
                                  ),
                                ))),
                ),
              ),

              const SizedBox(width: 12),

              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '№${task.id}: ${task.title}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isLocked
                            ? Colors.grey
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: badgeColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+${task.xp} XP',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.xp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Action arrow or lock
              Icon(
                isLocked
                    ? Icons.lock_outline_rounded
                    : Icons.chevron_right_rounded,
                color: isLocked ? Colors.grey : moduleColor,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
