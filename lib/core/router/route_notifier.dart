import 'package:flutter/material.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  final Future<bool> Function() checkAuth;
  bool? _isAuthenticated;

  GoRouterRefreshNotifier(this.checkAuth) {
    _init();
  }

  bool? get value => _isAuthenticated;
  set value(bool? newValue) {
    _isAuthenticated = newValue;
    notifyListeners();
  }

  Future<void> _init() async {
    _isAuthenticated = await checkAuth();
    notifyListeners(); // Asegura que GoRouter detecte el cambio
  }

  Future<void> refresh() async {
    bool newAuthState = await checkAuth();

    value = newAuthState;
    notifyListeners();
  }
}
