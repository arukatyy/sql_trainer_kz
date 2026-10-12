import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/progress_service.dart';
import '../../services/task_service.dart';
import '../../models/sql_task.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_provider.dart';
import '../../services/theme_provider.dart';
import '../../core/localization/translator.dart';
import '../achievements/achievements_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    final progress = progressProvider.progress;
    final allTasksCount = TaskService().allTasks.length;

    // Calculate stats
    int solvedIndependently = 0;
    int solvedWithHint = 0;
    int solutionViewed = 0;

    for (var statusStr in progress.taskStatuses.values) {
      if (statusStr == TaskStatus.solved.toString().split('.').last) {
        solvedIndependently++;
      } else if (statusStr == TaskStatus.solvedWithHint.toString().split('.').last) {
        solvedWithHint++;
      } else if (statusStr == TaskStatus.solutionViewed.toString().split('.').last) {
        solutionViewed++;
      }
    }

    final totalSolved = solvedIndependently + solvedWithHint;
    final progressPercent = allTasksCount > 0 ? totalSolved / allTasksCount : 0.0;

    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.userName;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profile_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            tooltip: 'Шығу',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(context, progress.levelName, progress.totalXp, userName),
            const SizedBox(height: 24),
            _buildStatsCard(
              context,
              allTasksCount: allTasksCount,
              totalSolved: totalSolved,
              solvedIndependently: solvedIndependently,
              solvedWithHint: solvedWithHint,
              solutionViewed: solutionViewed,
              progressPercent: progressPercent,
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(context, progressProvider),
            const SizedBox(height: 24),
            _buildLogoutButton(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String levelName, int totalXp, String? userName) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(60),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.person_rounded, size: 54, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          userName ?? 'Студент',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Деңгей: $levelName',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, color: AppColors.xp, size: 20),
            Text(
              ' $totalXp XP',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.xp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCard(
    BuildContext context, {
    required int allTasksCount,
    required int totalSolved,
    required int solvedIndependently,
    required int solvedWithHint,
    required int solutionViewed,
    required double progressPercent,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Шешімдер статистикасы',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _StatRow(label: 'Барлық тапсырма:', value: '$allTasksCount'),
            _StatRow(label: 'Шешілгені:', value: '$totalSolved', valueColor: AppColors.success),
            _StatRow(label: 'Өз бетімен:', value: '$solvedIndependently'),
            _StatRow(label: 'Көмекпен:', value: '$solvedWithHint', valueColor: AppColors.secondary),
            _StatRow(label: 'Шешімі көрілген:', value: '$solutionViewed', valueColor: AppColors.warning),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Жалпы прогресс',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  '${(progressPercent * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressPercent,
                backgroundColor: isDark ? Colors.white.withAlpha(20) : Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, ProgressProvider provider) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(context.tr('dark_theme'), style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            secondary: Icon(Icons.dark_mode, color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54),
            value: themeProvider.isDarkMode,
            onChanged: (val) {
              themeProvider.toggleTheme();
            },
            activeThumbColor: AppColors.primary,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.language, color: Theme.of(context).iconTheme.color),
            title: Text(context.tr('language'), style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            trailing: DropdownButton<String>(
              value: Provider.of<Translator>(context).currentLang,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  Provider.of<Translator>(context, listen: false).setLanguage(newValue);
                }
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.amber),
            title: Text(context.tr('achievements'), style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AchievementsScreen()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: Text(context.tr('reset_progress'), style: TextStyle(color: AppColors.error)),
            onTap: () => _showResetConfirmation(context, provider),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.info_outline, color: Theme.of(context).iconTheme.color),
            title: Text(context.tr('about'), style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).cardColor,
                  title: Text('SQL Тренажері', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                  content: Text('SQL үйренуге және тәжірибеден өтуге арналған интерактивті мобильді жаттықтырғыш.\nНұсқа 1.0.0\n\nБарлық деректеріңіз жергілікті түрде сақталады.', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.tr('ok')),
                    )
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: AppColors.error),
            title: Text(context.tr('logout'), style: const TextStyle(color: AppColors.error)),
            onTap: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withAlpha(35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutConfirmation(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.error.withAlpha(20),
        ),
        icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
        label: const Text(
          'Жүйеден шығу',
          style: TextStyle(
            color: AppColors.error,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Жүйеден шығу',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Шынымен жүйеден шыққыңыз келе ме? Қайта кіру үшін логин мен құпиясөзді енгізу қажет болады.',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Болдырмау'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Шығу', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, ProgressProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Прогресті қалпына келтіру', style: TextStyle(color: Colors.white)),
        content: const Text('Прогресіңізді толық қалпына келтіргіңіз келетініне сенімдісіз бе? Бұл әрекетті қайтару мүмкін емес.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Болдырмау', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              provider.resetProgress();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Прогресс сәтті қалпына келтірілді')),
              );
            },
            child: const Text('Қалпына келтіру', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
