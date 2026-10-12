import 'package:flutter/material.dart';
import '../data/databases/sample_databases.dart';
import '../services/sql_engine.dart';
import 'result_table.dart';
import '../core/theme/app_colors.dart';

class DatabaseSchema extends StatefulWidget {
  final String databaseName;

  const DatabaseSchema({super.key, required this.databaseName});

  @override
  State<DatabaseSchema> createState() => _DatabaseSchemaState();
}

class _DatabaseSchemaState extends State<DatabaseSchema> {
  bool _isExpanded = false;
  final SqlEngine _sqlEngine = SqlEngine();

  void _showTableData(BuildContext context, String tableName) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$tableName кестесінің деректері (10 қатарға дейін)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _sqlEngine.executeQuery('SELECT * FROM $tableName LIMIT 10;', widget.databaseName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return const Center(child: Text('Деректерді жүктеу қатесі'));
                    }
                    if (snapshot.data!.hasError) {
                      return Center(child: Text('Қате: ${snapshot.data!.errorMessage}', style: const TextStyle(color: Colors.red)));
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
    final schema = databaseSchemas[widget.databaseName];
    if (schema == null) return const SizedBox.shrink();

    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (val) {
            setState(() {
              _isExpanded = val;
            });
          },
          title: const Text('Дерекқор құрылымы', style: TextStyle(fontWeight: FontWeight.bold)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: schema.entries.map((e) => _buildTableSchema(context, e.key, e.value)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableSchema(BuildContext context, String tableName, String columnsStr) {
    final columns = columnsStr.split(',').map((e) => e.trim()).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$tableName кестесі',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 16),
              ),
              InkWell(
                onTap: () => _showTableData(context, tableName),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.remove_red_eye, color: Colors.blueAccent, size: 18),
                      const SizedBox(width: 4),
                      Text('Деректер', style: TextStyle(color: Colors.blueAccent.withAlpha(200), fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.black26 : Colors.black.withAlpha(10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withAlpha(50)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: columns.map((col) {
                final parts = col.split(' ');
                final colName = parts.first;
                final colType = parts.length > 1 ? parts.sublist(1).join(' ') : '';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary.withAlpha(50)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(colName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color)),
                      if (colType.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(colType, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ]
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
