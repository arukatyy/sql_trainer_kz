import 'dart:io';

void main() {
  var file = File('lib/widgets/sql_editor.dart');
  var content = file.readAsStringSync();

  // Replace colors
  content = content.replaceAll("Colors.blueAccent", "const Color(0xFFC678DD)"); // Pink for keywords
  content = content.replaceAll("Colors.green", "const Color(0xFF98C379)"); // Green for strings
  content = content.replaceAll("Colors.orange", "const Color(0xFFD19A66)"); // Orange for numbers
  
  // Make background darker like VSCode OneDark
  content = content.replaceAll("color: Colors.black54,", "color: const Color(0xFF282C34),");
  
  // Change text style to look more like code
  content = content.replaceAll("style: const TextStyle(fontSize: 16, height: 1.5, fontFamily: 'monospace'),", "style: const TextStyle(fontSize: 15, height: 1.6, fontFamily: 'monospace', color: Color(0xFFABB2BF)),"); // Base color

  // Change gutter background
  content = content.replaceAll("color: Colors.black26,", "color: const Color(0xFF21252B),");
  
  // Gutter text color
  content = content.replaceAll("color: Colors.white54", "color: const Color(0xFF4B5363)");

  file.writeAsStringSync(content);
}
