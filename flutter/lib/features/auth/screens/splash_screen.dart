import 'dart:async';

import 'package:afalagi/core/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Spacer(),

            CustomImages.appLogo(height: 75),
            const SizedBox(height: 20),
            const Text(
              'Your Real Estate Success, Simplified.',
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              backgroundColor: Colors.grey[300],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _navigate() {
    Timer(Duration(seconds: 3), () {
      context.go('/login');
    });
  }

  @override
  void initState() {
    super.initState();
    _navigate();
  }
}
