import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import 'screens/home/home_screen.dart';
import 'services/progress_service.dart';
import 'services/storage_service.dart';
import 'services/auth_provider.dart';
import 'services/theme_provider.dart';
import 'core/localization/translator.dart';
import 'screens/progress/progress_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/articles/articles_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final storageService = StorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProgressProvider(storageService)),
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => Translator()),
      ],
      child: const SqlTrainerApp(),
    ),
  );
}

class SqlTrainerApp extends StatelessWidget {
  const SqlTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SQL Тренажері',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const MainNavigation();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}



class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const ProgressScreen(),
    const ArticlesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor?.withAlpha(150) ?? Colors.black.withAlpha(150),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onTap: (index) {
                HapticFeedback.lightImpact();
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.home), label: context.tr('nav_trainer')),
                BottomNavigationBarItem(icon: const Icon(Icons.category), label: context.tr('nav_categories')),
                BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: context.tr('nav_progress')),
                BottomNavigationBarItem(icon: const Icon(Icons.library_books), label: context.tr('nav_handbook')),
                BottomNavigationBarItem(icon: const Icon(Icons.person), label: context.tr('nav_profile')),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
