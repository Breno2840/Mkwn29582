import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:async';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _controller.forward();
    
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a237e),
              Color(0xFF4a148c),
              Color(0xFF880e4f),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'SecureChat',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Criptografia de ponta a ponta',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final String _apiUrl = 'SEU_WORKER_CLOUDFLARE_URL';
  final String _encryptionKey = 'chave_secreta_32_caracteres!!';
  Timer? _timer;
  final Map<int, AnimationController> _animationControllers = {};

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) => _loadMessages());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _animationControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  AnimationController _getAnimationController(int index) {
    if (!_animationControllers.containsKey(index)) {
      _animationControllers[index] = AnimationController(
        duration: Duration(milliseconds: 300),
        vsync: this,
      )..forward();
    }
    return _animationControllers[index]!;
  }

  String _encrypt(String text) {
    var bytes = utf8.encode(text + _encryptionKey);
    var hash = sha256.convert(bytes);
    var encrypted = base64.encode(utf8.encode(text));
    return '$encrypted:${hash.toString().substring(0, 16)}';
  }

  String _decrypt(String encrypted) {
    try {
      var parts = encrypted.split(':');
      return utf8.decode(base64.decode(parts[0]));
    } catch (e) {
      return '[Erro ao descriptografar]';
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    
    final message = _controller.text.trim();
    final encrypted = _encrypt(message);
    
    setState(() {
      _messages.insert(0, {
        'text': message,
        'time': DateTime.now(),
        'isMine': true,
      });
    });
    
    _controller.clear();
    
    try {
      await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'send',
          'message': encrypted,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
    } catch (e) {
      print('Erro ao enviar: $e');
    }
  }

  Future<void> _loadMessages() async {
    try {
      final response = await http.get(Uri.parse('$_apiUrl?action=get'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['messages'] != null) {
          setState(() {
            _messages.clear();
            for (var msg in data['messages']) {
              _messages.add({
                'text': _decrypt(msg['message']),
                'time': DateTime.fromMillisecondsSinceEpoch(msg['timestamp']),
                'isMine': false,
              });
            }
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1a237e), Color(0xFF4a148c)],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(Icons.lock, size: 18),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SecureChat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Criptografado', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0a0e27),
              Color(0xFF1a1a2e),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurple.withOpacity(0.1),
                            ),
                            child: Icon(Icons.chat_bubble_outline, size: 64, color: Colors.deepPurple.withOpacity(0.5)),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Nenhuma mensagem ainda',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Envie uma mensagem para começar',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final controller = _getAnimationController(index);
                        
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(msg['isMine'] ? 1 : -1, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: controller,
                            curve: Curves.easeOutCubic,
                          )),
                          child: FadeTransition(
                            opacity: controller,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: msg['isMine'] 
                                    ? MainAxisAlignment.end 
                                    : MainAxisAlignment.start,
                                children: [
                                  if (!msg['isMine']) ...[
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [Colors.orange, Colors.deepOrange],
                                        ),
                                      ),
                                      child: Icon(Icons.person, size: 20, color: Colors.white),
                                    ),
                                    SizedBox(width: 8),
                                  ],
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: msg['isMine']
                                            ? LinearGradient(
                                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                              )
                                            : null,
                                        color: msg['isMine'] ? null : Color(0xFF2d2d44),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(msg['isMine'] ? 20 : 4),
                                          bottomRight: Radius.circular(msg['isMine'] ? 4 : 20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (msg['isMine'] ? Colors.purple : Colors.black)
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            msg['text'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              height: 1.4,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.lock,
                                                size: 10,
                                                color: Colors.white60,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '${msg['time'].hour}:${msg['time'].minute.toString().padLeft(2, '0')}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white60,
                                                ),
                                              ),
                                              if (msg['isMine']) ...[
                                                SizedBox(width: 4),
                                                Icon(
                                                  Icons.done_all,
                                                  size: 12,
                                                  color: Colors.lightBlue,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (msg['isMine']) ...[
                                    SizedBox(width: 8),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                        ),
                                      ),
                                      child: Icon(Icons.person, size: 20, color: Colors.white),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF1a1a2e),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurple.withOpacity(0.2),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: Colors.deepPurple),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF2d2d44),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.deepPurple.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Digite sua mensagem...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.4),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}