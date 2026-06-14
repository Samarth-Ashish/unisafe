import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../admin/admin_dashboard.dart';
import '../student/student_homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

import 'login_page.dart';

// v7: use singleton instance
final _googleSignIn = GoogleSignIn.instance;
bool _isGoogleSignInInitialized = false;

Future<void> _ensureInitialized() async {
  if (!_isGoogleSignInInitialized) {
    await _googleSignIn.initialize();
    _isGoogleSignInInitialized = true;
  }
}

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});
  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  ValueNotifier<UserCredential?> userCredential = ValueNotifier(null);
  int? blockNumber = 0;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    signOutFromGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userCredential,
      builder: (context, value, child) {
        if (userCredential.value == null) {
          return SignupPage(userCredential: userCredential);
        } else {
          return FutureBuilder(
            future: fetchAllowedEmails(userCredential.value?.user?.email ?? ''),
            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 15),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<String> allowedEmails = snapshot.data!;
                String currentUserEmail = userCredential.value?.user?.email ?? '';
                if (allowedEmails.contains(currentUserEmail)) {
                  return AdminDashboard(userCredential: userCredential, block: blockNumber!);
                } else {
                  return StudentHomePage(userCredential: userCredential);
                }
              }
            },
          );
        }
      },
    );
  }

  Future<List<String>> fetchAllowedEmails(String userEmail) async {
    try {
      CollectionReference adminsCollection = FirebaseFirestore.instance.collection('admins');
      DocumentSnapshot adminListDoc = await adminsCollection.doc('admin_list').get();

      Map<String, dynamic>? adminEmailsMap = adminListDoc['admins_with_block'];

      if (adminEmailsMap != null) {
        List<String> allowedEmails = adminEmailsMap.keys.toList();
        blockNumber = adminEmailsMap[userEmail];
        return allowedEmails;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching allowed emails: $e');
      throw Exception('Failed to fetch allowed emails');
    }
  }
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    await _ensureInitialized();

    // v7: authenticate() replaces signIn()
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(scopeHint: ['email']);

    // v7: authentication is now synchronous (no await)
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Get access token via authorizationClient
    final authorization = await _googleSignIn.authorizationClient.authorizationForScopes(['email']);

    final credential = GoogleAuthProvider.credential(accessToken: authorization?.accessToken, idToken: googleAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on GoogleSignInException catch (e) {
    debugPrint('Google Sign-In error: ${e.code.name} - ${e.description}');
    return null;
  } catch (e) {
    debugPrint('Sign in with Google failed: $e');
    return null;
  }
}

Future<bool> checkIfAdmin(String userEmail) async {
  try {
    DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance.collection('admins').doc('admin_list').get();

    if (adminSnapshot.exists) {
      List<dynamic> adminEmails = adminSnapshot['admins_with_block'];
      if (adminEmails.contains(userEmail)) {
        return true;
      }
    }
  } catch (e) {
    debugPrint('Error checking admin status: $e');
  }
  return false;
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    await _ensureInitialized();
    await _googleSignIn.signOut();
    debugPrint('Logged out successfully');
    return true;
  } catch (e) {
    debugPrint('Sign out failed: $e');
    return false;
  }
}
