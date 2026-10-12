import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isAuthenticated = false;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  String? get userName => _userName;

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await _authService.isLoggedIn();
    if (_isAuthenticated) {
      _userName = await _authService.getUserName();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      _isAuthenticated = true;
      _userName = await _authService.getUserName();
      notifyListeners();
    }
    return success;
  }

  Future<bool> register(String name, String email, String password) async {
    final success = await _authService.register(name, email, password);
    // Registration succeeds, user must log in explicitly on LoginScreen
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _userName = null;
    notifyListeners();
  }
}
