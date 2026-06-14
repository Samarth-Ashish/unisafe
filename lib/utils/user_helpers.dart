import 'package:firebase_auth/firebase_auth.dart';

String getUserName(UserCredential? cred) =>
    cred?.user?.displayName ?? 'Unknown User';

String getUserEmail(UserCredential? cred) =>
    cred?.user?.email ?? '';

String getUserPhoto(UserCredential? cred) =>
    cred?.user?.photoURL ?? 'https://ui-avatars.com/api/?name=User&background=random';