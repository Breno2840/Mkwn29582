// lib/presentation/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe o pacote para formatação de data/hora
import 'package:app/core/models/contact_model.dart';
import 'package:app/core/models/message_model.dart';
import 'package:app/core/services/database_helper.dart';
import 'package:app/core/services/encryption_service.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final Contact contact;

  const ChatScreen({super.key, required this.username, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Message> _messages = [];
  late final String _chatId;

  @override
  void initState() {
    super.initState();
    final names = [widget.username, widget.contact.name];
    names.sort();
    _chatId = names.join('-');
    _loadMessages();
  }

  void _loadMessages() async {
    final loadedMessages = await DatabaseHelper.instance.getMessages(_chatId);
    setState(() => _messages.addAll(loadedMessages));
    _scrollToBottom(instant: true);
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final encryptedText = EncryptionService.encryptText(text);
      final newMessage = Message(
        sender: widget.username,
        encryptedContent: encryptedText,
        timestamp: DateTime.now(),
      );
      await DatabaseHelper.instance.insertMessage(newMessage, _chatId);
      setState(() => _messages.add(newMessage));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom({bool instant = false}) {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        final position = _scrollController.position.maxScrollExtent;
        if (instant) {
          _scrollController.jumpTo(position);
        } else {
          _scrollController.animateTo(position, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Adicionando o avatar do contato na AppBar para um visual mais rico
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.contact.avatarUrl),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Text(widget.contact.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.sender == widget.username;
                final decryptedContent = EncryptionService.decryptText(message.encryptedContent);
                
                // Passamos a mensagem inteira para o widget do balão
                return _buildMessageBubble(message, isMe, decryptedContent);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  // --- WIDGET DO BALÃO DE MENSAGEM ATUALIZADO ---
  Widget _buildMessageBubble(Message message, bool isMe, String content) {
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = isMe ? Colors.deepPurple : const Color(0xFF3A3A3A);
    
    // Define bordas diferentes para o usuário e para o contato
    final borderRadius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(4), // Canto reto
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(4), // Canto reto
            bottomLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
          );

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 3,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Conteúdo da mensagem
            Text(
              content,
              style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.3),
            ),
            const SizedBox(height: 5),
            // Hora da mensagem
            Text(
              DateFormat('HH:mm').format(message.timestamp), // Formata a hora (ex: 14:30)
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(hintText: 'Digite sua mensagem...'),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send, size: 28),
            onPressed: _sendMessage,
            color: Colors.deepPurpleAccent,
          ),
        ],
      ),
    );
  }
}
