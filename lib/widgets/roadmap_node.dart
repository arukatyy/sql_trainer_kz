import 'package:flutter/material.dart';
import '../models/sql_task.dart';
import '../core/theme/app_colors.dart';

class RoadmapNode extends StatelessWidget {
  final SqlTask task;
  final bool isLocked;
  final bool isNext;
  final double alignmentOffset; // -1.0 to 1.0
  final VoidCallback onTap;

  const RoadmapNode({
    super.key,
    required this.task,
    required this.isLocked,
    required this.isNext,
    required this.alignmentOffset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color nodeColor = AppColors.primary;
    if (isLocked) {
      nodeColor = Colors.grey.withAlpha(50);
    } else if (task.status == TaskStatus.solved || task.status == TaskStatus.solvedWithHint || task.status == TaskStatus.solutionViewed) {
      nodeColor = Colors.amber; // Solved
    } else if (isNext) {
      nodeColor = AppColors.success; // Active
    }

    // Determine the winding offset
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 40.0),
      child: Align(
        alignment: Alignment(alignmentOffset, 0),
        child: GestureDetector(
          onTap: isLocked ? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Алдымен алдыңғы тапсырмаларды шешіңіз!')),
            );
          } : onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isNext)
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: nodeColor.withAlpha(50),
                      ),
                    ),
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          nodeColor.withAlpha(200),
                          nodeColor,
                          nodeColor.withAlpha(150),
                        ],
                      ),
                      boxShadow: [
                        if (!isLocked)
                          BoxShadow(
                            color: nodeColor.withAlpha(150),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        if (!isLocked)
                          BoxShadow(
                            color: Colors.white.withAlpha(50),
                            blurRadius: 2,
                            offset: const Offset(0, -2),
                          ),
                      ],
                      border: isNext ? Border.all(color: Colors.white, width: 4) : Border.all(color: Colors.white.withAlpha(20), width: 1),
                    ),
                    child: Center(
                      child: Icon(
                        _getIcon(),
                        color: isLocked ? Colors.grey : Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 140,
                child: Text(
                  task.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                    color: isLocked ? Colors.grey : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    if (isLocked) return Icons.lock;
    if (task.status == TaskStatus.solved || task.status == TaskStatus.solvedWithHint || task.status == TaskStatus.solutionViewed) return Icons.star;
    if (isNext) return Icons.play_arrow;
    return Icons.code;
  }
}
