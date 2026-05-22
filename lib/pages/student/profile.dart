import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final ValueNotifier userCredential;
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  widget.userCredential.value.user!.photoURL!.toString(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: ${widget.userCredential.value.user!.displayName!.toString()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${widget.userCredential.value.user!.email!.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
            // Add other user info here
          ],
        ),
      ),
    );
  }
}
