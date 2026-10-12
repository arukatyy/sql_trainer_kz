import 'dart:io';

void main() {
  var file = File('lib/main.dart');
  var content = file.readAsStringSync();

  content = content.replaceFirst("class MainNavigation extends StatefulWidget {", "import 'dart:ui';\nimport 'package:flutter/services.dart';\n\nclass MainNavigation extends StatefulWidget {");
  
  var newNav = '''
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
''';

  content = content.replaceFirst(
    RegExp(r'return Scaffold\(\s*body: _screens\[_currentIndex\],\s*bottomNavigationBar: BottomNavigationBar\(.*?\),\s*\);', dotAll: true),
    newNav,
  );
  file.writeAsStringSync(content);
}
