// lib/presentation/screens/contact_list_screen.dart

import 'package:flutter/material.dart';
import 'package:app/core/models/contact_model.dart';
import 'package:app/presentation/screens/chat_screen.dart';
import 'package:app/presentation/screens/settings_screen.dart'; // Importar
import 'package:app/presentation/screens/login_screen.dart'; // Importar
import 'package:app/core/services/preferences_service.dart'; // Importar

class ContactListScreen extends StatefulWidget {
  final String username;
  const ContactListScreen({super.key, required this.username});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  // ... (código dos contatos fictícios) ...
  final List<Contact> _contacts = [
    Contact(name: 'Alice', avatarUrl: 'https://i.pravatar.cc/150?img=1', lastMessage: 'Olá! Tudo bem?', time: '10:40'),
    Contact(name: 'Bob', avatarUrl: 'https://i.pravatar.cc/150?img=2', lastMessage: 'Nos vemos mais tarde.', time: '10:35'),
    Contact(name: 'Carol', avatarUrl: 'https://i.pravatar.cc/150?img=3', lastMessage: 'Reunião confirmada.', time: '09:12'),
  ];

  void _navigateToChat(Contact contact) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(username: widget.username, contact: contact),
      ),
    );
  }

  // Função para fazer logout
  void _logout() async {
    await PreferencesService().clearUsername();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false, // Remove todas as rotas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversas'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          // PopupMenuButton para o menu de 3 pontos
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Configurações'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        // ... (resto do body sem alterações) ...
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(contact.avatarUrl), radius: 28),
            title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(contact.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(contact.time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            onTap: () => _navigateToChat(contact),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
