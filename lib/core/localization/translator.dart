import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Translator extends ChangeNotifier {
  static const String _langKey = 'app_lang';
  String _currentLang = 'kk';

  String get currentLang => _currentLang;

  Translator() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLang = prefs.getString(_langKey) ?? 'kk';
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    if (!['ru', 'en', 'kk'].contains(lang)) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, lang);
    _currentLang = lang;
    notifyListeners();
  }

  String translate(String key) {
    return _translations[_currentLang]?[key] ?? _translations['kk']?[key] ?? _translations['ru']?[key] ?? key;
  }

  static final Map<String, Map<String, String>> _translations = {
    'ru': {
      // Bottom Nav
      'nav_trainer': 'Тренажёр',
      'nav_categories': 'Категории',
      'nav_progress': 'Прогресс',
      'nav_handbook': 'Учебник',
      'nav_profile': 'Профиль',
      
      // Splash
      'splash_subtitle': 'Изучай базы данных на практике',

      // Auth
      'login_title': 'С возвращением!',
      'login_subtitle': 'Войдите, чтобы продолжить',
      'email_hint': 'Email',
      'password_hint': 'Пароль',
      'login_btn': 'Войти',
      'no_account': 'Нет аккаунта? Зарегистрироваться',
      'reg_title': 'Создать аккаунт',
      'reg_subtitle': 'Начните изучать SQL сегодня',
      'name_hint': 'Имя',
      'reg_btn': 'Зарегистрироваться',
      'have_account': 'Уже есть аккаунт? Войти',
      'error_fields': 'Заполните все поля',
      'error_login': 'Неверный email или пароль',
      'error_reg': 'Ошибка регистрации',

      // Home
      'level': 'Уровень',
      'sandbox': 'Песочница',
      'search_tasks': 'Поиск заданий...',
      'all_tasks': 'Все',
      'daily_challenge': 'Задача дня',
      
      // Profile
      'profile_title': 'Профиль',
      'dark_theme': 'Тёмная тема',
      'achievements': 'Мои достижения',
      'reset_progress': 'Сбросить прогресс',
      'about': 'О приложении',
      'logout': 'Выйти из аккаунта',
      'language': 'Язык (Language)',
      
      // Task
      'task_condition': 'Условие задачи',
      'task_schema': 'Структура базы данных',
      'task_expected_btn': 'Какой результат нужно получить?',
      'task_solution': 'Решение:',
      'task_run': 'Выполнить',
      'task_correct': 'Правильно!',
      'task_correct_desc': 'Запрос вернул ожидаемый результат.',
      'task_back': 'К списку заданий',
      'task_error': 'Результат отличается от ожидаемого',
      'task_compare': 'Сравнить с ожидаемым результатом',
      'task_your_result': 'Ваш результат:',
      'task_expected_result': 'Ожидаемый результат',
      'task_hint': 'Подсказка',
      'task_show_solution': 'Показать решение',
      'task_solution_warn': 'Если вы посмотрите решение, вы не получите XP за эту задачу. Продолжить?',
      'cancel': 'Отмена',
      'show': 'Показать',
      'paste_code': 'Вставить код',
      'close': 'Закрыть',

      // Articles
      'articles_title': 'Учебник и Статьи',
      'articles_subtitle': 'Дополнительные материалы по SQL, лучшие практики и теория',
      'all_articles': 'Все статьи',
      'read_time': 'мин чтения',
      
      // General
      'ok': 'ОК',
      'yes': 'Да',
      'no': 'Нет',
    },
    'en': {
      'nav_trainer': 'Trainer',
      'nav_categories': 'Categories',
      'nav_progress': 'Progress',
      'nav_handbook': 'Handbook',
      'nav_profile': 'Profile',
      
      'splash_subtitle': 'Learn databases in practice',

      'login_title': 'Welcome back!',
      'login_subtitle': 'Sign in to continue',
      'email_hint': 'Email',
      'password_hint': 'Password',
      'login_btn': 'Sign In',
      'no_account': 'No account? Sign up',
      'reg_title': 'Create Account',
      'reg_subtitle': 'Start learning SQL today',
      'name_hint': 'Name',
      'reg_btn': 'Sign Up',
      'have_account': 'Already have an account? Sign In',
      'error_fields': 'Fill in all fields',
      'error_login': 'Invalid email or password',
      'error_reg': 'Registration error',

      'level': 'Level',
      'sandbox': 'Sandbox',
      'search_tasks': 'Search tasks...',
      'all_tasks': 'All',
      'daily_challenge': 'Daily Challenge',
      
      'profile_title': 'Profile',
      'dark_theme': 'Dark Theme',
      'achievements': 'My Achievements',
      'reset_progress': 'Reset Progress',
      'about': 'About app',
      'logout': 'Sign Out',
      'language': 'Language',
      
      'task_condition': 'Task Condition',
      'task_schema': 'Database Schema',
      'task_expected_btn': 'What result should I get?',
      'task_solution': 'Solution:',
      'task_run': 'Run',
      'task_correct': 'Correct!',
      'task_correct_desc': 'The query returned the expected result.',
      'task_back': 'Back to tasks',
      'task_error': 'Result differs from expected',
      'task_compare': 'Compare with expected result',
      'task_your_result': 'Your result:',
      'task_expected_result': 'Expected result',
      'task_hint': 'Hint',
      'task_show_solution': 'Show Solution',
      'task_solution_warn': 'If you view the solution, you will not receive XP for this task. Continue?',
      'cancel': 'Cancel',
      'show': 'Show',
      'paste_code': 'Paste code',
      'close': 'Close',

      'articles_title': 'Handbook & Articles',
      'articles_subtitle': 'Additional SQL materials, best practices and theory',
      'all_articles': 'All articles',
      'read_time': 'min read',
      
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
    },
    'kk': {
      'nav_trainer': 'Жаттықтырғыш',
      'nav_categories': 'Санаттар',
      'nav_progress': 'Прогресс',
      'nav_handbook': 'Оқулық',
      'nav_profile': 'Профиль',
      
      'splash_subtitle': 'Дерекқорларды тәжірибеде үйрен',

      'login_title': 'Қайта оралуыңызбен!',
      'login_subtitle': 'Жалғастыру үшін жүйеге кіріңіз',
      'email_hint': 'Электрондық пошта',
      'password_hint': 'Құпиясөз',
      'login_btn': 'Кіру',
      'no_account': 'Аккаунтыңыз жоқ па? Тіркелу',
      'reg_title': 'Аккаунт жасау',
      'reg_subtitle': 'SQL үйренуді бүгін бастаңыз',
      'name_hint': 'Аты',
      'reg_btn': 'Тіркелу',
      'have_account': 'Аккаунтыңыз бар ма? Кіру',
      'error_fields': 'Барлық өрістерді толтырыңыз',
      'error_login': 'Электрондық пошта немесе құпиясөз қате',
      'error_reg': 'Тіркелу қатесі',

      'level': 'Деңгей',
      'sandbox': 'Құмсалғыш',
      'search_tasks': 'Тапсырмаларды іздеу...',
      'all_tasks': 'Барлығы',
      'daily_challenge': 'Күннің тапсырмасы',
      
      'profile_title': 'Профиль',
      'dark_theme': 'Қараңғы тақырып',
      'achievements': 'Менің жетістіктерім',
      'reset_progress': 'Прогресті қалпына келтіру',
      'about': 'Қосымша туралы',
      'logout': 'Жүйеден шығу',
      'language': 'Тіл (Language)',
      
      'task_condition': 'Тапсырма шарты',
      'task_schema': 'Дерекқор құрылымы',
      'task_expected_btn': 'Қандай нәтиже алу керек?',
      'task_solution': 'Шешім:',
      'task_run': 'Орындау',
      'task_correct': 'Дұрыс!',
      'task_correct_desc': 'Сұрау күтілген нәтижені қайтарды.',
      'task_back': 'Тапсырмалар тізіміне',
      'task_error': 'Нәтиже күтілгеннен өзгеше',
      'task_compare': 'Күтілген нәтижемен салыстыру',
      'task_your_result': 'Сіздің нәтижеңіз:',
      'task_expected_result': 'Күтілетін нәтиже',
      'task_hint': 'Кеңес',
      'task_show_solution': 'Шешімін көрсету',
      'task_solution_warn': 'Егер сіз шешімді қарасаңыз, бұл тапсырма үшін XP алмайсыз. Жалғастырасыз ба?',
      'cancel': 'Болдырмау',
      'show': 'Көрсету',
      'paste_code': 'Кодты қою',
      'close': 'Жабу',

      'articles_title': 'Оқулық және Мақалалар',
      'articles_subtitle': 'Қосымша SQL материалдары, үздік тәжірибелер мен теория',
      'all_articles': 'Барлық мақалалар',
      'read_time': 'мин оқу',
      
      'ok': 'ОК',
      'yes': 'Иә',
      'no': 'Жоқ',
    }
  };
}

extension TranslateExt on BuildContext {
  String tr(String key) {
    return Provider.of<Translator>(this, listen: true).translate(key);
  }
}
