import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/progress_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/sql_task.dart';
import '../profile/certificate_screen.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    final progress = progressProvider.progress;

    // Check achievement conditions dynamically
    int totalSolved = 0;
    int independentSolved = 0;
    for (var statusStr in progress.taskStatuses.values) {
      if (statusStr == TaskStatus.solved.toString().split('.').last) {
        totalSolved++;
        independentSolved++;
      } else if (statusStr == TaskStatus.solvedWithHint.toString().split('.').last) {
        totalSolved++;
      }
    }

    final achievements = [
      _AchievementDef(
        title: 'Алғашқы сұраныс',
        description: 'Алғашқы тапсырмаңызды шешіңіз.',
        icon: Icons.flag,
        isUnlocked: totalSolved >= 1,
      ),
      _AchievementDef(
        title: 'Оқушы',
        description: '5 тапсырманы шешіңіз.',
        icon: Icons.menu_book,
        isUnlocked: totalSolved >= 5,
      ),
      _AchievementDef(
        title: 'SQL Әзірлеушісі',
        description: '10 тапсырманы шешіңіз.',
        icon: Icons.computer,
        isUnlocked: totalSolved >= 10,
      ),
      _AchievementDef(
        title: 'Тәуелсіз зерде',
        description: '5 тапсырманы толық өз бетіңізбен шешіңіз (көмексіз).',
        icon: Icons.psychology,
        isUnlocked: independentSolved >= 5,
      ),
      _AchievementDef(
        title: 'Табандылық',
        description: 'Қосымшаға қатарынан 3 күн кіріңіз.',
        icon: Icons.local_fire_department,
        isUnlocked: progress.streakDays >= 3,
      ),
    ];

    int unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Жетістіктер'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black12,
            child: Text(
              'Ашылды: $unlockedCount / ${achievements.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final ach = achievements[index];
                return Card(
                  color: Theme.of(context).cardColor,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: ach.isUnlocked ? Colors.amber.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
                      child: Icon(ach.icon, color: ach.isUnlocked ? Colors.amber : Colors.grey),
                    ),
                    title: Text(
                      ach.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ach.isUnlocked ? Colors.white : Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      ach.description,
                      style: TextStyle(
                        color: ach.isUnlocked ? Colors.white70 : Colors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                    trailing: ach.isUnlocked
                        ? const Icon(Icons.check_circle, color: AppColors.success)
                        : const Icon(Icons.lock, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CertificateScreen()));
              },
              icon: const Icon(Icons.workspace_premium),
              label: const Text('Сертификат алу'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementDef {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;

  _AchievementDef({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}
