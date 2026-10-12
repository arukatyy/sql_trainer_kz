import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

Future<void> sendWebRegister(String name, String email, String password) async {
  try {
    final request = html.HttpRequest();
    request.open('POST', 'http://127.0.0.1:8765/api/register');
    request.setRequestHeader('Content-Type', 'application/json');
    request.send(jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    }));
  } catch (_) {
    // Ignore network failures if sync server is not active
  }
}
