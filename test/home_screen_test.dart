import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sql_trainer_kz/screens/home/home_screen.dart';
import 'package:sql_trainer_kz/services/progress_service.dart';
import 'package:sql_trainer_kz/services/storage_service.dart';
import 'package:sql_trainer_kz/core/localization/translator.dart';
import 'package:sql_trainer_kz/services/auth_provider.dart';

void main() {
  testWidgets('HomeScreen renders without crashing', (WidgetTester tester) async {
    final storageService = StorageService();
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProgressProvider(storageService)),
          ChangeNotifierProvider(create: (_) => Translator()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(SingleChildScrollView), findsWidgets);
  });
}
