import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/user_info_extensions.dart';
import '../../core/auth_session.dart';
import '../screens/sign_in_screen.dart';
import '../../service/admin_directory_service.dart';
import '../screens/admin_dashboard.dart';
import '../screens/student_homepage.dart';

/// Top-level routing widget: shows the sign-in screen, admin dashboard,
/// or student home page based on [AuthSession] + admin directory lookup.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AdminDirectoryService _adminDirectory = AdminDirectoryService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthSession>();

    if (!session.isSignedIn) {
      return SignInScreen(
        title: 'Welcome to UniSafe',
        logoAssetPath: 'assets/images/unisafeLogo.jpg',
        googleIconAssetPath: 'assets/images/google.png',
        onSignInPressed: () => session.signIn(),
      );
    }

    return FutureBuilder<Map<String, int>>(
      future: _adminDirectory.fetchAdminBlockMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue),
                  SizedBox(height: 15),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        final adminBlockMap = snapshot.data ?? {};
        final email = session.user.emailOrEmpty;

        if (_adminDirectory.isAdmin(email, adminBlockMap)) {
          final block = _adminDirectory.blockFor(email, adminBlockMap) ?? 0;
          return AdminDashboard(block: block);
        }

        return const StudentHomePage();
      },
    );
  }
}
