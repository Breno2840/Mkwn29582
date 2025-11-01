// lib/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:app/presentation/screens/theme_selection_screen.dart'; // Importa a nova tela

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      // Usamos uma ListView para criar uma lista de opções rolável
      body: ListView(
        children: [
          // Opção 1: Temas
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Aparência e Temas'),
            subtitle: const Text('Mude o visual do aplicativo'),
            onTap: () {
              // Navega para a tela dedicada à seleção de temas
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ThemeSelectionScreen()),
              );
            },
          ),
          const Divider(),

          // Opção 2: Conta (Exemplo para o futuro)
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Conta'),
            subtitle: const Text('Privacidade, segurança, mudar número'),
            onTap: () {
              // Ação para a tela de conta (a ser criada no futuro)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tela de Conta (a ser implementada)')),
              );
            },
          ),
          const Divider(),

          // Opção 3: Backup (Exemplo para o futuro)
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: const Text('Backup de Conversas'),
            subtitle: const Text('Faça backup ou restaure suas mensagens'),
            onTap: () {
              // Ação para a tela de backup (a ser criada no futuro)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tela de Backup (a ser implementada)')),
              );
            },
          ),
          const Divider(),
          
          // Opção 4: Notificações (Exemplo para o futuro)
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notificações'),
            subtitle: const Text('Sons de mensagem, grupos e chamadas'),
            onTap: () {
              // Ação para a tela de notificações (a ser criada no futuro)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tela de Notificações (a ser implementada)')),
              );
            },
          ),
        ],
      ),
    );
  }
}
