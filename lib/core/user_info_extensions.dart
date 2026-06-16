import 'package:firebase_auth/firebase_auth.dart';

/// Convenience accessors for displaying user info, with sensible
/// fallbacks when fields are missing.
///
/// Usage: `session.user.displayNameOrDefault`, `session.user.emailOrEmpty`
extension UserInfoExtensions on User? {
  String get displayNameOrDefault => this?.displayName ?? 'Unknown User';

  String get emailOrEmpty => this?.email ?? '';

  String get photoUrlOrPlaceholder =>
      this?.photoURL ?? 'https://ui-avatars.com/api/?name=User&background=random';
}