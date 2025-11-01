// lib/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/services/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temas do Aplicativo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Grid para exibir as opções de tema
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: AppThemes.allThemes.length,
                itemBuilder: (context, index) {
                  final theme = AppThemes.allThemes[index];
                  return GestureDetector(
                    onTap: () {
                      // Ação de trocar o tema
                      themeProvider.setTheme(theme);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: themeProvider.getTheme == theme
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          'Tema ${index + 1}',
                          style: TextStyle(
                            color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
