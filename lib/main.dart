// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/services/theme_provider.dart';
import 'package:app/presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // Envolvemos o app com o ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(AppThemes.darkTheme), // Tema inicial
      child: const ChatApp(),
    ),
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    // O Consumer ouve as mudanças no ThemeProvider
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Chat Criptografado',
          theme: themeProvider.getTheme, // Usa o tema do provider
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
