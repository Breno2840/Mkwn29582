// lib/core/services/theme_provider.dart

import 'package:flutter/material.dart';

// Classe que notifica os ouvintes (widgets) quando o tema muda
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get getTheme => _themeData;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notifica a UI para reconstruir com o novo tema
  }
}

// Lista de temas que vamos oferecer
class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1F1F1F)),
    // ... outras propriedades do tema escuro padrão
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
    // ... outras propriedades do tema claro
  );
  
  static final ThemeData forestTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: const Color(0xFF1A2421),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.teal),
    // ...
  );

  // Aqui adicionaremos os outros 7 temas no futuro
  static List<ThemeData> get allThemes => [darkTheme, lightTheme, forestTheme];
}
