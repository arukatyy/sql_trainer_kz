import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'tactile_button.dart';

class SqlTextController extends TextEditingController {
  final RegExp _pattern = RegExp(
    r"\b(SELECT|FROM|WHERE|JOIN|LEFT|RIGHT|INNER|OUTER|ON|GROUP BY|ORDER BY|HAVING|LIMIT|OFFSET|AS|AND|OR|NOT|IN|IS|NULL|COUNT|MAX|MIN|SUM|AVG|CREATE|ALTER|DROP|TABLE|INSERT|INTO|VALUES|UPDATE|SET|DELETE)\b|'.*?'|\b\d+\b",
    caseSensitive: false,
  );

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<TextSpan> children = [];
    text.splitMapJoin(
      _pattern,
      onMatch: (Match match) {
        final text = match.group(0)!;
        TextStyle? colorStyle;
        if (text.startsWith("'")) {
          colorStyle = const TextStyle(color: Color(0xFF98C379));
        } else if (int.tryParse(text) != null) {
          colorStyle = const TextStyle(color: Color(0xFFD19A66));
        } else if (RegExp(r'^(CREATE|ALTER|DROP|TABLE|INSERT|INTO|VALUES|UPDATE|SET|DELETE)$', caseSensitive: false).hasMatch(text)) {
          colorStyle = const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold);
        } else {
          colorStyle = const TextStyle(color: Color(0xFFC678DD), fontWeight: FontWeight.bold);
        }
        children.add(TextSpan(text: text, style: style?.merge(colorStyle)));
        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );
    return TextSpan(style: style, children: children);
  }
}

class SqlEditor extends StatefulWidget {
  final SqlTextController controller;
  final VoidCallback onRun;
  final VoidCallback onClear;

  const SqlEditor({
    super.key,
    required this.controller,
    required this.onRun,
    required this.onClear,
  });

  @override
  State<SqlEditor> createState() => _SqlEditorState();
}

class _SqlEditorState extends State<SqlEditor> {
  final List<String> _quickKeywords = [
    'SELECT', 'FROM', 'WHERE', 'JOIN', 'ON', 'GROUP BY', 'ORDER BY', 'AND', 'OR', 'LIMIT'
  ];

  void _insertText(String insert) {
    final int cursorPosition = widget.controller.selection.baseOffset;
    final String text = widget.controller.text;
    final insertion = '$insert ';
    
    if (cursorPosition >= 0) {
      widget.controller.text = text.substring(0, cursorPosition) + insertion + text.substring(cursorPosition);
      widget.controller.selection = TextSelection.collapsed(offset: cursorPosition + insertion.length);
    } else {
      widget.controller.text += insertion;
      widget.controller.selection = TextSelection.collapsed(offset: widget.controller.text.length);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineCount = widget.controller.text.split('\n').length;
    final lines = List.generate(lineCount == 0 ? 1 : lineCount, (i) => (i + 1).toString()).join('\n');

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Заголовок редактора
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withAlpha(50) : Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'SQL редакторы',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: widget.onClear,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withAlpha(15) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.delete_outline_rounded, color: Theme.of(context).textTheme.bodyMedium?.color, size: 16),
                  ),
                ),
              ],
            ),
          ),
          
          // Поле ввода с нумерацией строк
          SizedBox(
            height: 160,
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Нумерация строк
                  Container(
                    width: 32,
                    padding: const EdgeInsets.only(top: 10, bottom: 12, right: 8),
                    color: isDark ? Colors.black12 : Colors.grey[100],
                    child: Text(
                      lines,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.firaCode(
                        textStyle: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                      ),
                    ),
                  ),
                  // Текстовое поле
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 4),
                      child: TextField(
                        controller: widget.controller,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: GoogleFonts.firaCode(
                          textStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'SQL сұранысын жазыңыз...',
                          hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black38),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Быстрые клавиши (Автодополнение)
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.withAlpha(50))),
              color: isDark ? Colors.black26 : Colors.grey[50],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickKeywords.length,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: ActionChip(
                    label: Text(_quickKeywords[index], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _insertText(_quickKeywords[index]),
                  ),
                );
              },
            ),
          ),

          // Кнопка выполнения
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TactileButton(
              color: AppColors.success,
              shadowColor: AppColors.successShadow,
              borderRadius: 16,
              onPressed: widget.onRun,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Орындау',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
