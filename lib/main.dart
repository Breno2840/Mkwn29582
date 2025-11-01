// lib/main.dart

import 'package:flutter/material.dart';
import 'package:app/presentation/screens/splash_screen.dart'; // Import da nova estrutura

void main() {
  // Garante que os bindings do Flutter sejam inicializados antes de qualquer coisa.
  // Essencial para o sqflite e shared_preferences funcionarem corretamente.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Criptografado',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
        cardColor: const Color(0xFF1E1E1E),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
