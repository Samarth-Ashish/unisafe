import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Generic wrapper around Google Sign-In + Firebase Auth.
/// Contains no app-specific logic, safe to drop into any
/// Firebase + Google Sign-In project as-is.
class GoogleAuthService {
  GoogleAuthService._();
  static final GoogleAuthService instance = GoogleAuthService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize();
      _isInitialized = true;
    }
  }

  /// Signs in with Google and returns the resulting Firebase
  /// [UserCredential], or null if sign-in failed or was cancelled.
  Future<UserCredential?> signIn({List<String> scopes = const ['email']}) async {
    try {
      await _ensureInitialized();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(scopeHint: scopes);
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final authorization = await _googleSignIn.authorizationClient.authorizationForScopes(scopes);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      debugPrint('Google Sign-In error: ${e.code.name} - ${e.description}');
      return null;
    } catch (e) {
      debugPrint('Sign in with Google failed: $e');
      return null;
    }
  }

  /// Signs out of both Firebase Auth and Google Sign-In.
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _ensureInitialized();
      await _googleSignIn.signOut();
      debugPrint('Signed out successfully');
      return true;
    } catch (e) {
      debugPrint('Sign out failed: $e');
      return false;
    }
  }
}