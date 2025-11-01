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
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: AppThemes.allThemes.length,
          itemBuilder: (context, index) {
            final theme = AppThemes.allThemes[index];
            final themeName = _getThemeName(theme);

            return GestureDetector(
              onTap: () {
                themeProvider.setTheme(theme);
              },
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // O gradiente agora usa as cores primária e secundária corretas de cada tema
                        gradient: LinearGradient(
                          colors: [theme.primaryColor, theme.colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: themeProvider.getTheme == theme
                            ? Border.all(color: theme.colorScheme.secondary, width: 3)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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

  // Função auxiliar atualizada com todos os nomes
  String _getThemeName(ThemeData theme) {
    if (theme == AppThemes.darkTheme) return 'Padrão Escuro';
    if (theme == AppThemes.lightTheme) return 'Claro';
    if (theme == AppThemes.forestTheme) return 'Floresta';
    if (theme == AppThemes.oceanTheme) return 'Oceano';
    if (theme == AppThemes.sunsetTheme) return 'Crepúsculo';
    if (theme == AppThemes.roseTheme) return 'Rosa';
    if (theme == AppThemes.midnightTheme) return 'Meia-noite';
    if (theme == AppThemes.coffeeTheme) return 'Café';
    if (theme == AppThemes.grapeTheme) return 'Uva';
    if (theme == AppThemes.mintTheme) return 'Menta';
    return 'Tema ${AppThemes.allThemes.indexOf(theme) + 1}';
  }
}
