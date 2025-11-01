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

// --- LISTA COMPLETA E CORRIGIDA DE 10 TEMAS ---
class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF4A148C), // Roxo escuro
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7B1FA2),
      secondary: Colors.deepPurpleAccent, // Roxo mais vibrante
      background: Color(0xFF121212),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1F1F1F)),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue, // Azul
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.lightBlueAccent, // Azul claro
      background: Color(0xFFF5F5F5),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
  );
  
  static final ThemeData forestTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[800], // Verde escuro
    colorScheme: ColorScheme.dark(
      primary: Colors.green[800]!,
      secondary: Colors.tealAccent[400]!, // Verde claro/azulado
      background: const Color(0xFF1A2421),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A2421),
    appBarTheme: AppBarTheme(backgroundColor: Colors.green[900]),
  );

  static final ThemeData oceanTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue[900], // Azul profundo
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[900]!,
      secondary: Colors.cyanAccent, // Ciano
      background: const Color(0xFF0A192F),
    ),
    scaffoldBackgroundColor: const Color(0xFF0A192F),
    appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF0A192F)),
  );

  static final ThemeData sunsetTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.orange[900], // Laranja escuro
    colorScheme: ColorScheme.dark(
      primary: Colors.orange[900]!,
      secondary: Colors.amberAccent, // Amarelo
      background: const Color(0xFF2C1A1D),
    ),
    scaffoldBackgroundColor: const Color(0xFF2C1A1D),
    appBarTheme: AppBarTheme(backgroundColor: Colors.deepOrange[800]),
  );

  static final ThemeData roseTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.pink[300], // Rosa
    colorScheme: ColorScheme.light(
      primary: Colors.pink[300]!,
      secondary: Colors.redAccent, // Vermelho claro
      background: const Color(0xFFFFF0F5),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF0F5),
    appBarTheme: AppBarTheme(backgroundColor: Colors.pink[300]),
  );

  static final ThemeData midnightTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF263238), // Cinza azulado muito escuro
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF263238),
      secondary: Colors.blueGrey, // Cinza azulado
      background: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF263238)),
  );

  static final ThemeData coffeeTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6D4C41), // Marrom
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6D4C41),
      secondary: Color(0xFFA1887F), // Marrom claro
      background: Color(0xFFEFEBE9),
    ),
    scaffoldBackgroundColor: const Color(0xFFEFEBE9),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF5D4037)),
  );

  static final ThemeData grapeTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF6A1B9A), // Roxo uva
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6A1B9A),
      secondary: Color(0xFFCE93D8), // Lilás
      background: const Color(0xFF241B2F),
    ),
    scaffoldBackgroundColor: const Color(0xFF241B2F),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF4A148C)),
  );

  static final ThemeData mintTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.teal[300], // Verde menta
    colorScheme: ColorScheme.light(
      primary: Colors.teal[300]!,
      secondary: Colors.lightGreenAccent, // Verde limão
      background: const Color(0xFFF0FAF8),
    ),
    scaffoldBackgroundColor: const Color(0xFFF0FAF8),
    appBarTheme: AppBarTheme(backgroundColor: Colors.teal[300]),
  );

  // Lista final com todos os 10 temas
  static List<ThemeData> get allThemes => [
    darkTheme, lightTheme, forestTheme, oceanTheme, sunsetTheme, 
    roseTheme, midnightTheme, coffeeTheme, grapeTheme, mintTheme
  ];
}
