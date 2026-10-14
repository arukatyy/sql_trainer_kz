import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_trainer_kz/main.dart';
import 'package:sql_trainer_kz/services/progress_service.dart';
import 'package:sql_trainer_kz/services/storage_service.dart';
import 'package:sql_trainer_kz/services/auth_provider.dart';
import 'package:sql_trainer_kz/services/theme_provider.dart';
import 'package:sql_trainer_kz/core/localization/translator.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'hasSeenOnboarding': true});
    final storageService = StorageService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProgressProvider(storageService)),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => Translator()),
        ],
        child: const SqlTrainerApp(),
      ),
    );

    // Allow splash timer to complete
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('SQL Тренажері'), findsAtLeastNWidgets(1));
  });
}
