import 'package:flutter/material.dart';
import '../../services/sql_engine.dart';
import '../../widgets/sql_editor.dart';
import '../../widgets/result_table.dart';
import '../../models/query_result.dart';
import '../../data/databases/sample_databases.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final SqlTextController _queryController = SqlTextController();
  final SqlEngine _sqlEngine = SqlEngine();
  
  String _selectedDb = 'sql_trainer';
  QueryResult? _result;
  bool _isLoading = false;

  void _runQuery() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    final res = await _sqlEngine.executeQuery(query, _selectedDb);

    setState(() {
      _result = res;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Құмсалғыш (Playground)'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Еркін режим',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 8),
              Text(
                'Кез келген SQL сұраныстарын жазыңыз. Кестелер жасауға, деректерді өзгертуге немесе таңдау жасауға болады.',
                style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Дерекқор:', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedDb,
                      dropdownColor: Theme.of(context).cardColor,
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                      items: sampleDatabases.keys.map((db) {
                        return DropdownMenuItem(
                          value: db,
                          child: Text(db.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedDb = val;
                            _result = null;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SqlEditor(
                controller: _queryController,
                onRun: _runQuery,
                onClear: () => _queryController.clear(),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_result != null) ...[
                Text('Нәтиже:', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                const SizedBox(height: 8),
                ResultTable(result: _result!),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
