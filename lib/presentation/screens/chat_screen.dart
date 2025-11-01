// lib/presentation/screens/chat_screen.dart

import 'package:flutter/material.dart';
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
        title: Text(widget.contact.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.sender == widget.username;
                final decryptedContent = EncryptionService.decryptText(message.encryptedContent);
                return _buildMessageBubble(isMe, decryptedContent);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(bool isMe, String content) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.deepPurple : const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(content, style: const TextStyle(color: Colors.white, fontSize: 16)),
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
