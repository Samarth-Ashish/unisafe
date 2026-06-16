import 'package:flutter/material.dart';

/// A generic, themeable "Sign in with Google" screen.
/// Reusable across projects, branding is supplied via constructor params.
class SignInScreen extends StatelessWidget {
  final String title;
  final String logoAssetPath;
  final String googleIconAssetPath;
  final Color backgroundColor;
  final Color buttonBorderColor;
  final Color buttonTextColor;
  final Future<void> Function() onSignInPressed;

  const SignInScreen({
    super.key,
    required this.title,
    required this.logoAssetPath,
    required this.googleIconAssetPath,
    required this.onSignInPressed,
    this.backgroundColor = const Color.fromARGB(255, 255, 157, 104),
    this.buttonBorderColor = Colors.purple,
    this.buttonTextColor = Colors.deepOrange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                const SizedBox(height: 60.0),
                Text(
                  title,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (rect) {
                    return RadialGradient(
                      center: Alignment.center,
                      radius: 0.55,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                      stops: const [0.5, 1.0],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(logoAssetPath, height: 400, fit: BoxFit.contain),
                ),
              ],
            ),
            GoogleSignInButton(
              iconAssetPath: googleIconAssetPath,
              borderColor: buttonBorderColor,
              textColor: buttonTextColor,
              onPressed: onSignInPressed,
            ),
          ],
        ),
      ),
    );
  }
}

/// A standalone "Sign in with Google" button.
/// Usable on its own (e.g. in a settings/account-linking page) or as
/// part of [SignInScreen].
class GoogleSignInButton extends StatelessWidget {
  final String iconAssetPath;
  final Color borderColor;
  final Color textColor;
  final String label;
  final Future<void> Function() onPressed;

  const GoogleSignInButton({
    super.key,
    required this.iconAssetPath,
    required this.onPressed,
    this.borderColor = Colors.purple,
    this.textColor = Colors.deepOrange,
    this.label = 'Sign In with Google',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(iconAssetPath, fit: BoxFit.cover),
            ),
            const SizedBox(width: 18),
            Text(
              label,
              style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}