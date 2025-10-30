import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt; // Usamos um alias para evitar conflitos

// --- MODELOS DE DADOS ---

// Representa uma única mensagem no chat
class Message {
  final String sender;
  final String encryptedContent; // Armazenamos o conteúdo criptografado
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.encryptedContent,
    required this.timestamp,
  });
}

// --- SERVIÇO DE CRIPTOGRAFIA ---

// Classe responsável por criptografar e descriptografar as mensagens.
// Em um app real, a chave seria gerenciada de forma muito mais segura.
class EncryptionService {
  // ATENÇÃO: A chave e o IV (Vetor de Inicialização) nunca devem ser fixos no código em um app de produção.
  // Eles devem ser gerados de forma segura, derivados de uma senha do usuário ou negociados com um servidor.
  // Para este exemplo local, estamos usando valores fixos.
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!'); // Chave de 32 bytes para AES-256
  static final _iv = encrypt.IV.fromLength(16); // IV de 16 bytes para AES
  
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));

  // Criptografa um texto plano
  static String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64; // Retornamos a string em base64 para facilitar o armazenamento
  }

  // Descriptografa um texto em base64
  static String decryptText(String encryptedBase64) {
    try {
      final decrypted = _encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedBase64), iv: _iv);
      return decrypted;
    } catch (e) {
      // Se a descriptografia falhar (ex: chave errada, dados corrompidos), retorna um aviso.
      return "Falha ao descriptografar a mensagem.";
    }
  }
}


// --- PONTO DE ENTRADA DA APLICAÇÃO ---

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
      home: const SplashScreen(), // A aplicação começa na Splash Screen
      debugShowCheckedModeBanner: false,
    );
  }
}


// --- TELAS (SCREENS) ---

// 1. Tela de Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navega para a tela de login após 3 segundos
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

// 2. Tela de Login
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChatScreen(username: username),
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
                  label: const Text('Entrar no Chat'),
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


// 3. Tela de Bate-papo
class ChatScreen extends StatefulWidget {
  final String username;
  const ChatScreen({super.key, required this.username});

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
      // 1. Criptografa o texto antes de criar o objeto Message
      final encryptedText = EncryptionService.encryptText(text);

      setState(() {
        _messages.add(Message(
          sender: widget.username,
          encryptedContent: encryptedText,
          timestamp: DateTime.now(),
        ));
      });
      _messageController.clear();

      // Anima a lista para a última mensagem
      Future.delayed(const Duration(milliseconds: 100), () {
        if(_scrollController.hasClients){
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
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
        title: Text('Chat como ${widget.username}'),
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
                
                // 2. Descriptografa o conteúdo para exibição
                final decryptedContent = EncryptionService.decryptText(message.encryptedContent);

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.deepPurple : const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Text(
                            message.sender,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurpleAccent,
                              fontSize: 12,
                            ),
                          ),
                        if (!isMe) const SizedBox(height: 4),
                        Text(
                          decryptedContent,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
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
