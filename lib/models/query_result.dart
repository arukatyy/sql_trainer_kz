class QueryResult {
  final List<String> columns;
  final List<List<dynamic>> rows;
  final String? errorMessage;
  final bool hasError;

  QueryResult({
    required this.columns,
    required this.rows,
    this.errorMessage,
    this.hasError = false,
  });

  factory QueryResult.error(String message) {
    return QueryResult(
      columns: [],
      rows: [],
      errorMessage: message,
      hasError: true,
    );
  }

  factory QueryResult.fromList(List<Map<String, Object?>> data) {
    if (data.isEmpty) {
      return QueryResult(columns: [], rows: []);
    }
    List<String> cols = data.first.keys.toList();
    List<List<dynamic>> rows = data.map((e) => cols.map((c) => e[c]).toList()).toList();
    return QueryResult(columns: cols, rows: rows);
  }
}
