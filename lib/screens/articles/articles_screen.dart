import '../../core/localization/translator.dart';
import 'package:flutter/material.dart';
import '../../models/article.dart';
import '../../data/articles_data.dart';
import '../../core/theme/app_colors.dart';
import 'article_detail_screen.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  String _selectedCategory = 'ALL';

  List<String> get _categories {
    final cats = mockArticles.map((e) => e.category).toSet().toList();
    cats.insert(0, 'ALL');
    return cats;
  }

  @override
  Widget build(BuildContext context) {
    final filteredArticles = _selectedCategory == 'ALL'
        ? mockArticles
        : mockArticles.where((a) => a.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('articles_title')),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              context.tr('articles_subtitle'),
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          
          // Горизонтальный список категорий
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  child: ChoiceChip(
                    label: Text(category == 'ALL' ? context.tr('all_articles') : category),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                    backgroundColor: Theme.of(context).cardColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 8),

          // Список статей (Уникальный Layout)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                final isFeatured = index == 0 && _selectedCategory == 'ALL';

                return _ArticleCard(
                  article: article,
                  isFeatured: isFeatured,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  final bool isFeatured;
  final VoidCallback onTap;

  const _ArticleCard({
    required this.article,
    this.isFeatured = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Уникальный цвет карточки на основе категории
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withAlpha(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Декоративный фоновый элемент
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: categoryColor.withAlpha(isDark ? 30 : 20),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Метка категории и время чтения
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            article.readTime,
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Заголовок
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: isFeatured ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Описание
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(180),
                      height: 1.5,
                    ),
                    maxLines: isFeatured ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Дата и стрелка
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.date,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Theme.of(context).textTheme.bodyLarge?.color?.withAlpha(100),
                        size: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
