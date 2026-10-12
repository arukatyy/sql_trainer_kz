import 'dart:io';

void main() {
  var file = File('lib/screens/home/home_screen.dart');
  var content = file.readAsStringSync();

  content = content.replaceFirst("import '../../core/theme/app_colors.dart';", "import '../../core/theme/app_colors.dart';\nimport 'dart:ui';");

  var newAppBar = '''
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              title: Text(context.tr('nav_trainer')),
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(150),
            ),
          ),
        ),
      ),
''';

  content = content.replaceFirst(
    RegExp(r"      appBar: AppBar\(\s*title: Text\(context\.tr\('nav_trainer'\)\),\s*elevation: 0,\s*backgroundColor: Colors\.transparent,\s*\),", dotAll: true),
    newAppBar,
  );
  file.writeAsStringSync(content);
}
