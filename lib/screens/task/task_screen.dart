import '../../core/localization/translator.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

import '../../services/sql_engine.dart';
import '../../services/progress_service.dart';
import '../../models/sql_task.dart';
import '../../models/query_result.dart';
import '../../widgets/database_schema.dart';
import '../../widgets/sql_editor.dart';
import '../../widgets/result_table.dart';
import '../../core/theme/app_colors.dart';

class TaskScreen extends StatefulWidget {
  final SqlTask task;

  const TaskScreen({super.key, required this.task});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late ConfettiController _confettiController;

  final SqlTextController _queryController = SqlTextController();
  final SqlEngine _sqlEngine = SqlEngine();

  QueryResult? _userResult;
  QueryResult? _expectedResult;
  bool? _isCorrect;
  bool _isLoading = false;
  int _hintsUsed = 0;
  bool _solutionViewed = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();

    _queryController.dispose();
    super.dispose();
  }

  void _runQuery() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _userResult = null;
      _isCorrect = null;
    });

    final isCorrect = await _sqlEngine.checkAnswer(
      query,
      widget.task.expectedQuery,
      widget.task.databaseName,
    );
    final userResult = await _sqlEngine.executeQuery(
      query,
      widget.task.databaseName,
    );

    // Also fetch expected result to show difference if wrong
    QueryResult? expectedResult;
    if (!isCorrect && !userResult.hasError) {
      expectedResult = await _sqlEngine.executeQuery(
        widget.task.expectedQuery,
        widget.task.databaseName,
      );
    }

    setState(() {
      _userResult = userResult;
      _expectedResult = expectedResult;
      _isCorrect = isCorrect;
      _isLoading = false;
    });

    if (isCorrect && mounted) {
      HapticFeedback.heavyImpact();
      _confettiController.play();
      int xpEarned = widget.task.xp;
      TaskStatus status = TaskStatus.solved;

      if (_solutionViewed) {
        xpEarned = 0;
        status = TaskStatus.solutionViewed;
      } else if (_hintsUsed > 0) {
        xpEarned = (xpEarned / 2).round();
        status = TaskStatus.solvedWithHint;
      }
      Provider.of<ProgressProvider>(
        context,
        listen: false,
      ).updateTaskStatus(widget.task.id, status, xpEarned);
    } else if (mounted) {
      HapticFeedback.vibrate();
    }
  }

  void _showHint() {
    if (_hintsUsed < widget.task.hints.length) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Кеңес ${_hintsUsed + 1}',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          content: Text(
            widget.task.hints[_hintsUsed],
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _hintsUsed++;
                });
                Navigator.pop(context);
              },
              child: const Text('Түсінікті'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Басқа кеңес жоқ!')));
    }
  }

  void _showSolution() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Назар аударыңыз'),
        content: const Text(
          'Егер сіз шешімді көрсеңіз, бұл тапсырма үшін XP алмайсыз. Жалғастырасыз ба?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Болдырмау'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _solutionViewed = true;
              });
              _showActualSolution();
            },
            child: const Text('Көрсету', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showActualSolution() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Шешім',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        content: Text(
          widget.task.expectedQuery,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontFamily: 'monospace',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _queryController.text = widget.task.expectedQuery;
            },
            child: const Text('Кодты енгізу'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('close')),
          ),
        ],
      ),
    );
  }

  void _showExpectedResultTable() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('task_expected_result'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<QueryResult>(
                  future: _sqlEngine.executeQuery(
                    widget.task.expectedQuery,
                    widget.task.databaseName,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Center(child: Text('Орындалу қатесі'));
                    }
                    return ResultTable(result: snapshot.data!);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Тапсырма №${widget.task.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: _showHint,
            tooltip: context.tr('task_hint'),
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _showSolution,
            tooltip: context.tr('task_show_solution'),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Карточка условия задачи
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(15),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(40),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.assignment_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.task.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1),
                          ),
                          Text(
                            widget.task.taskCondition,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Кнопка предпросмотра результата
                    OutlinedButton.icon(
                      onPressed: _showExpectedResultTable,
                      icon: const Icon(Icons.table_chart_outlined, size: 20),
                      label: Text(context.tr('task_expected_btn')),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),

                    const SizedBox(height: 16),
                    DatabaseSchema(databaseName: widget.task.databaseName),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Icon(Icons.keyboard, color: Colors.grey, size: 20),
                        SizedBox(width: 8),
                        Text(
                          context.tr('task_solution'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    SqlEditor(
                      controller: _queryController,
                      onRun: _runQuery,
                      onClear: () => _queryController.clear(),
                    ),

                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_userResult != null)
                      _buildResultSection(),
                  ],
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
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isCorrect == true)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success),
                    SizedBox(width: 8),
                    Text(
                      context.tr('task_correct'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(context.tr('task_correct_desc')),
                const SizedBox(height: 8),
                Text(
                  _solutionViewed
                      ? 'Шешімі көрілді: +0 XP'
                      : '+${_hintsUsed > 0 ? (widget.task.xp / 2).round() : widget.task.xp} XP',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(context.tr('task_back')),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error),
                    SizedBox(width: 8),
                    Text(
                      context.tr('task_error'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                if (_expectedResult != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: OutlinedButton.icon(
                      onPressed:
                          _showExpectedResultTable, // Reusing the same modal!
                      icon: const Icon(Icons.compare_arrows),
                      label: Text(context.tr('task_compare')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 24),
        Text(
          context.tr('task_your_result'),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ResultTable(result: _userResult!),
      ],
    );
  }
}
