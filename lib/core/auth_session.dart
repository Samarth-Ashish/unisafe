import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:unisafe/service/google_auth_service.dart';


/// Holds the current authenticated user and notifies listeners on change.
///
/// Register once via `MultiProvider` (alongside `ThemeProvider`), then read
/// it anywhere with `context.watch<AuthSession>()` instead of threading a
/// `ValueNotifier<UserCredential?>` through every page's constructor.
class AuthSession extends ChangeNotifier {
  final GoogleAuthService _authService;

  AuthSession({GoogleAuthService? authService}) : _authService = authService ?? GoogleAuthService.instance;

  UserCredential? _credential;

  UserCredential? get credential => _credential;
  User? get user => _credential?.user;
  bool get isSignedIn => _credential != null;

  /// Signs in with Google, updates session state, and notifies listeners.
  /// Returns the resulting credential, or null on failure/cancellation.
  Future<UserCredential?> signIn() async {
    final result = await _authService.signIn();
    if (result != null) {
      _credential = result;
      notifyListeners();
    }
    return result;
  }

  /// Signs out, clears session state, and notifies listeners.
  Future<bool> signOut() async {
    final success = await _authService.signOut();
    if (success) {
      _credential = null;
      notifyListeners();
    }
    return success;
  }
}