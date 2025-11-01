// lib/presentation/screens/theme_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/services/theme_provider.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Tema'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Mantém 3 colunas
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8, // Ajusta a proporção para caber o nome
          ),
          itemCount: AppThemes.allThemes.length,
          itemBuilder: (context, index) {
            final theme = AppThemes.allThemes[index];
            final themeName = _getThemeName(theme); // Pega o nome do tema

            return GestureDetector(
              onTap: () {
                themeProvider.setTheme(theme);
              },
              child: Column(
                children: [
                  // Círculo de pré-visualização da cor
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [theme.primaryColor, theme.colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: themeProvider.getTheme == theme
                            ? Border.all(color: Colors.grey.shade400, width: 3)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Nome do tema
                  Text(
                    themeName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Função auxiliar para dar nomes aos temas
  String _getThemeName(ThemeData theme) {
    if (theme == AppThemes.darkTheme) return 'Padrão Escuro';
    if (theme == AppThemes.lightTheme) return 'Claro';
    if (theme == AppThemes.forestTheme) return 'Floresta';
    return 'Tema ${AppThemes.allThemes.indexOf(theme) + 1}';
  }
}
