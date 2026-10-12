import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlideData> _slides = [
    _OnboardingSlideData(
      title: 'Интерактивті жаттықтырғыш',
      description: 'Телефонда нақты SQL-сұраныстар жазыңыз. Қосымша нәтижені өзі тексеріп, қателерді көрсетеді.',
      icon: Icons.code,
      color: Colors.blueAccent,
    ),
    _OnboardingSlideData(
      title: 'Деңгейлер картасы',
      description: 'Жаңадан бастаушыдан дерекқор шеберіне дейінгі қызықты жолдан өтіңіз. Тәжірибе жинап, жетістіктерді ашыңыз!',
      icon: Icons.map,
      color: Colors.orangeAccent,
    ),
    _OnboardingSlideData(
      title: 'Оқулық әрқашан қолжетімді',
      description: 'JOIN немесе WHERE синтаксисін ұмытып қалдыңыз ба? Түсінікті мақалалары мен мысалдары бар анықтамалықты ашыңыз.',
      icon: Icons.school,
      color: Colors.green,
    ),
  ];

  void _onNextPressed() async {
    if (_currentPage == _slides.length - 1) {
      // Сберечь флаг
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RootScreen()),
        );
      }
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(_slides[index]);
            },
          ),
          
          // Индикатор страниц и кнопка "Далее"
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Точки (Индикатор)
                Row(
                  children: List.generate(
                    _slides.length,
                    (index) => _buildDot(index: index),
                  ),
                ),
                // Кнопка
                ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Бастау!' : 'Келесі',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          // Кнопка "Пропустить"
          if (_currentPage < _slides.length - 1)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  _pageController.jumpToPage(_slides.length - 1);
                },
                child: const Text('Өткізіп жіберу', style: TextStyle(color: Colors.grey)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlide(_OnboardingSlideData data) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: data.color.withAlpha(30),
            ),
            child: Icon(
              data.icon,
              size: 100,
              color: data.color,
            ),
          ),
          const SizedBox(height: 60),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 10,
      width: _currentPage == index ? 24 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primary : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class _OnboardingSlideData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _OnboardingSlideData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
