import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unisafe/utils/user_helpers.dart';

class ProfilePage extends StatefulWidget {
  final ValueNotifier<UserCredential?> userCredential;
  const ProfilePage({super.key, required this.userCredential});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, spreadRadius: 2)],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(getUserPhoto(widget.userCredential.value)),
                onBackgroundImageError: (_, _) {},
                child: getUserPhoto(widget.userCredential.value).isEmpty ? const Icon(Icons.person, size: 50) : null,
              ),
            ),
            const SizedBox(height: 16),
            Text('Name: ${getUserName(widget.userCredential.value)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Email: ${getUserEmail(widget.userCredential.value)}', style: const TextStyle(fontSize: 18)),
            // Add other user info here
          ],
        ),
      ),
    );
  }
}
