import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/progress_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    final progress = progressProvider.progress;

    return Scaffold(
      appBar: AppBar(title: const Text('Менің прогресім')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              progress.levelName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
            const SizedBox(height: 32),
            _buildProgressRow('XP', '${progress.totalXp}'),
            const SizedBox(height: 16),
            _buildProgressRow('Деңгей', '${progress.level}'),
            const SizedBox(height: 16),
            _buildProgressRow('Үздіксіз күндер', '🔥 ${progress.streakDays}'),
            const SizedBox(height: 16),
            _buildProgressRow('Шешілген тапсырмалар', '${progress.taskStatuses.values.where((s) => s.contains("solved")).length}'),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
