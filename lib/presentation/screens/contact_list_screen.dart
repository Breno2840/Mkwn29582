// lib/presentation/screens/contact_list_screen.dart

import 'package:flutter/material.dart';
import 'package:app/core/models/contact_model.dart';
import 'package:app/presentation/screens/chat_screen.dart';

class ContactListScreen extends StatefulWidget {
  final String username;
  const ContactListScreen({super.key, required this.username});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Contact> _contacts = [
    Contact(name: 'Alice', avatarUrl: 'https://i.pravatar.cc/150?img=1', lastMessage: 'Olá! Tudo bem?', time: '10:40'),
    Contact(name: 'Bob', avatarUrl: 'https://i.pravatar.cc/150?img=2', lastMessage: 'Nos vemos mais tarde.', time: '10:35'),
    Contact(name: 'Carol', avatarUrl: 'https://i.pravatar.cc/150?img=3', lastMessage: 'Reunião confirmada.', time: '09:12'),
    Contact(name: 'David', avatarUrl: 'https://i.pravatar.cc/150?img=4', lastMessage: 'Me envie o relatório.', time: 'Ontem'),
    Contact(name: 'Eve', avatarUrl: 'https://i.pravatar.cc/150?img=5', lastMessage: 'Ótima ideia!', time: 'Ontem'),
  ];

  void _navigateToChat(Contact contact) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(username: widget.username, contact: contact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversas'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(contact.avatarUrl), radius: 28),
            title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(contact.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[400])),
            trailing: Text(contact.time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            onTap: () => _navigateToChat(contact),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
