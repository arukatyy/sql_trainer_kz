import 'dart:io';

void main() {
  var file = File('lib/screens/task/task_screen.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll('''
    ],
  ),
    );
  }
''', '''
    ],
  ),
    );
  }
''');
}
