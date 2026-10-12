import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../models/article.dart';
import '../../core/theme/app_colors.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    Color categoryColor;
    switch (article.category) {
      case 'Негіздер':
      case 'Основы':
        categoryColor = Colors.blueAccent;
        break;
      case 'SQL тәжірибесі':
      case 'Практика SQL':
        categoryColor = Colors.purpleAccent;
        break;
      case 'Өнімділік':
      case 'Производительность':
        categoryColor = Colors.orangeAccent;
        break;
      default:
        categoryColor = AppColors.primary;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(article.category, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: categoryColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: categoryColor.withAlpha(100)),
                          ),
                          child: Text(
                            article.category,
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          article.readTime,
                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          article.date,
                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: MarkdownBody(
                  data: article.content,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      fontSize: 16, 
                      height: 1.6, 
                      color: Theme.of(context).textTheme.bodyMedium?.color
                    ),
                    h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                    h2: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                    h3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                    code: TextStyle(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey.withAlpha(50) 
                          : Colors.grey.withAlpha(30),
                      color: Colors.blueAccent,
                      fontFamily: 'monospace',
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.black26 
                          : Colors.black.withAlpha(15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    blockquoteDecoration: BoxDecoration(
                      border: Border(left: BorderSide(color: categoryColor, width: 4)),
                      color: categoryColor.withAlpha(20),
                    ),
                    blockquote: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(200),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
