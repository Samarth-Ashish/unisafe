import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/auth_session.dart';
import 'view/screens/auth_gate.dart';
import 'core/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: const String.fromEnvironment('FIREBASE_API_KEY'),
      authDomain: const String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
      projectId: const String.fromEnvironment('FIREBASE_PROJECT_ID'),
      storageBucket: const String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
      messagingSenderId: const String.fromEnvironment('FIREBASE_SENDER_ID'),
      appId: const String.fromEnvironment('FIREBASE_APP_ID'),
      measurementId: const String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthSession()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.currentTheme,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Firebase Web App',
          home: const AuthGate(),
        );
      },
    );
  }
}
