import 'dart:io';

void main() {
  var file = File('lib/widgets/roadmap_node.dart');
  var content = file.readAsStringSync();

  var oldDecoration = '''
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: nodeColor,
                      boxShadow: [
                        if (!isLocked)
                          BoxShadow(
                            color: nodeColor.withAlpha(100),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                      ],
                      border: isNext ? Border.all(color: Colors.white, width: 3) : null,
                    ),
''';

  var newDecoration = '''
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
''';

  content = content.replaceFirst(oldDecoration, newDecoration);

  // Add HapticFeedback on tap
  content = content.replaceFirst("import '../core/theme/app_colors.dart';", "import '../core/theme/app_colors.dart';\nimport 'package:flutter/services.dart';");
  content = content.replaceFirst("          child: GestureDetector(\n            onTap: isLocked ? () {", "          child: GestureDetector(\n            onTap: isLocked ? () {\n              HapticFeedback.vibrate();");
  content = content.replaceFirst("            } : onTap,", "            } : () {\n              HapticFeedback.lightImpact();\n              onTap();\n            },");

  file.writeAsStringSync(content);
}
