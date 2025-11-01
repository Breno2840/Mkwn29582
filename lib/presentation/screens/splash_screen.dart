// lib/presentation/screens/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app/core/services/preferences_service.dart';
import 'package:app/presentation/screens/contact_list_screen.dart';
import 'package:app/presentation/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _prefsService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final String? username = await _prefsService.getUsername();

    if (username != null && username.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ContactListScreen(username: username)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 100, color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            const Text('Chat Seguro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text('Carregando suas conversas...', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[400])),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent)),
          ],
        ),
      ),
    );
  }
}
