import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

// --- MODELOS DE DADOS ---

// Representa um único contato na lista
class Contact {
  final String name;
  final String avatarUrl; // URL para uma imagem de avatar
  final String lastMessage;
  final String time;

  Contact({
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
  });
}

// Representa uma única mensagem no chat
class Message {
  final String sender;
  final String encryptedContent;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.encryptedContent,
    required this.timestamp,
  });
}

// --- SERVIÇO DE CRIPTOGRAFIA (sem alterações) ---
class EncryptionService {
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!');
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));

  static String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedBase64) {
    try {
      final decrypted = _encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedBase64), iv: _iv);
      return decrypted;
    } catch (e) {
      return "Falha ao descriptografar.";
    }
  }
}

// --- PONTO DE ENTRADA DA APLICAÇÃO (sem alterações) ---
void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Criptografado',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
        cardColor: const Color(0xFF1E1E1E),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- TELAS (SCREENS) ---

// 1. Tela de Splash (sem alterações)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 100, color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            const Text(
              'Chat Seguro',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Suas conversas protegidas localmente.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Tela de Login (Navegação alterada)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final username = _nameController.text.trim();
      // ALTERAÇÃO: Navega para a tela de contatos, passando o nome do usuário
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ContactListScreen(username: username),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_pin, size: 80, color: Colors.deepPurpleAccent),
                const SizedBox(height: 20),
                const Text(
                  'Quem é você?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Seu nome de usuário',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira um nome.';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _login,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Entrar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 3. TELA DE LISTA DE CONTATOS (NOVA)
class ContactListScreen extends StatefulWidget {
  final String username;
  const ContactListScreen({super.key, required this.username});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  // Dados fictícios para a lista de contatos
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
        builder: (_) => ChatScreen(
          username: widget.username,
          contactName: contact.name, // Passa o nome do contato para a tela de chat
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar funcionalidade de busca
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implementar menu de opções
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(contact.avatarUrl),
              radius: 28,
            ),
            title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              contact.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: Text(contact.time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            onTap: () => _navigateToChat(contact),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar ação de novo chat
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}

// 4. Tela de Bate-papo (Atualizada)
class ChatScreen extends StatefulWidget {
  final String username; // Nome do usuário logado
  final String contactName; // Nome do contato com quem está conversando

  const ChatScreen({
    super.key,
    required this.username,
    required this.contactName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Message> _messages = [];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final encryptedText = EncryptionService.encryptText(text);
      setState(() {
        _messages.add(Message(
          sender: widget.username, // O remetente é sempre o usuário logado
          encryptedContent: encryptedText,
          timestamp: DateTime.now(),
        ));
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
        // ATUALIZAÇÃO: O título agora é o nome do contato
        title: Text(widget.contactName),
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

                // Em um app real, você teria mensagens do outro contato também.
                // Aqui, todas as mensagens são do usuário logado.
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.deepPurple : const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      decryptedContent,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
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
              decoration: const InputDecoration(
                hintText: 'Digite sua mensagem...',
              ),
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
