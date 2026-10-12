import 'package:flutter/material.dart';
import '../models/query_result.dart';

class ResultTable extends StatelessWidget {
  final QueryResult result;

  const ResultTable({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result.hasError) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red),
        ),
        child: Text(
          result.errorMessage ?? 'Белгісіз қате',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (result.columns.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Көрсететін деректер жоқ', style: TextStyle(color: Colors.grey)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
        child: DataTable(
          headingRowColor: WidgetStateProperty.resolveWith((states) => Colors.blueGrey.withValues(alpha: 0.3)),
          columns: result.columns
              .map((c) => DataColumn(
                    label: Text(
                      c,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          rows: result.rows
              .map((row) => DataRow(
                    cells: row
                        .map((cell) => DataCell(
                              Text(cell?.toString() ?? 'NULL'),
                            ))
                        .toList(),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
