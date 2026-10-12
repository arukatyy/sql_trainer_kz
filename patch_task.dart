import 'dart:io';

void main() {
  var file = File('lib/screens/task/task_screen.dart');
  var content = file.readAsStringSync();

  content = content.replaceFirst("import 'package:provider/provider.dart';", "import 'package:provider/provider.dart';\nimport 'package:confetti/confetti.dart';\nimport 'package:flutter/services.dart';");

  content = content.replaceFirst("class _TaskScreenState extends State<TaskScreen> {", '''
class _TaskScreenState extends State<TaskScreen> {
  late ConfettiController _confettiController;
''');

  content = content.replaceFirst("void initState() {", '''
void initState() {
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
''');

  content = content.replaceFirst("void dispose() {", '''
void dispose() {
    _confettiController.dispose();
''');

  content = content.replaceFirst("bool _isCorrect = true;", '''
bool _isCorrect = true;
          HapticFeedback.heavyImpact();
          _confettiController.play();
''');

  content = content.replaceFirst("bool _isCorrect = false;", '''
bool _isCorrect = false;
          HapticFeedback.vibrate();
''');

  content = content.replaceFirst("body: Padding(", '''
body: Stack(
        children: [
          Padding(''');

  content = content.replaceFirst("            ),\n          ),\n        ),\n      ),", '''
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
        ),
      ),
    ],
  ),''');

  file.writeAsStringSync(content);
}
