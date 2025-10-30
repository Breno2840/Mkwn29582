import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:async';

void main() => runApp(ChatApp());

// Gera ícone aleatório para o usuário
final List<IconData> randomIcons = [
  Icons.face, Icons.sentiment_satisfied, Icons.emoji_emotions,
  Icons.mood, Icons.tag_faces, Icons.person, Icons.account_circle,
];

final List<Color> randomColors = [
  Colors.blue, Colors.pink, Colors.orange, Colors.purple, 
  Colors.teal, Colors.red, Colors.green, Colors.indigo,
];

int _getUserIconIndex() => DateTime.now().millisecondsSinceEpoch % randomIcons.length;
int _getUserColorIndex() => DateTime.now().microsecondsSinceEpoch % randomColors.length;

IconData getUserIcon() => randomIcons[_getUserIconIndex()];
Color getUserColor() => randomColors[_getUserColorIndex()];

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

// ============ SPLASH SCREEN ============
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
        MaterialPageRoute(builder: (context) => ConversationsScreen()),
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

// ============ TELA DE CONVERSAS ============
class ConversationsScreen extends StatefulWidget {
  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _notificationsEnabled = true;
  bool _darkMode = true;
  
  final List<Map<String, dynamic>> contacts = [
    {
      'name': 'João Silva',
      'lastMessage': 'Oi! Tudo bem?',
      'time': '19:45',
      'unread': 2,
      'avatar': Icons.person,
      'color': Colors.blue,
      'online': true,
    },
    {
      'name': 'Maria Santos',
      'lastMessage': 'Vamos nos encontrar amanhã?',
      'time': '18:30',
      'unread': 0,
      'avatar': Icons.person,
      'color': Colors.pink,
      'online': true,
    },
    {
      'name': 'Pedro Costa',
      'lastMessage': 'Obrigado pela ajuda!',
      'time': '16:22',
      'unread': 0,
      'avatar': Icons.person,
      'color': Colors.orange,
      'online': false,
    },
    {
      'name': 'Ana Oliveira',
      'lastMessage': 'Você viu o vídeo que te mandei?',
      'time': '15:10',
      'unread': 5,
      'avatar': Icons.person,
      'color': Colors.purple,
      'online': true,
    },
    {
      'name': 'Carlos Mendes',
      'lastMessage': 'Até logo! 👋',
      'time': 'Ontem',
      'unread': 0,
      'avatar': Icons.person,
      'color': Colors.teal,
      'online': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1a1a2e),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Configurações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              secondary: Icon(Icons.notifications, color: Colors.blue),
              title: Text('Notificações'),
              subtitle: Text('Receber alertas de novas mensagens'),
              value: _notificationsEnabled,
              activeColor: Colors.greenAccent,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
              },
            ),
            SwitchListTile(
              secondary: Icon(Icons.dark_mode, color: Colors.purple),
              title: Text('Modo Escuro'),
              subtitle: Text('Tema escuro para o aplicativo'),
              value: _darkMode,
              activeColor: Colors.greenAccent,
              onChanged: (val) {
                setState(() => _darkMode = val);
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.orange),
              title: Text('Sobre o App'),
              subtitle: Text('SecureChat v1.0'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Color(0xFF1a1a2e),
                    title: Text('SecureChat'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Versão: 1.0.0'),
                        SizedBox(height: 10),
                        Text('App de mensagens com criptografia de ponta a ponta.'),
                        SizedBox(height: 10),
                        Text(
                          '🔒 Suas mensagens são criptografadas localmente antes de serem enviadas.',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(color: Colors.white.withOpacity(0.2)),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '✨ Mais opções em breve...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a237e),
              Color(0xFF0a0e27),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'SecureChat',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onPressed: _showSettingsMenu,
                    ),
                  ],
                ),
              ),
              
              // Lista de conversas
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                contactName: contact['name'],
                                contactColor: contact['color'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Color(0xFF1a1a2e).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          contact['color'],
                                          contact['color'].withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      contact['avatar'],
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  if (contact['online'])
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.greenAccent,
                                          border: Border.all(
                                            color: Color(0xFF0a0e27),
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          contact['name'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.lock,
                                          size: 12,
                                          color: Colors.green.withOpacity(0.8),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      contact['lastMessage'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white54,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    contact['time'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: contact['unread'] > 0
                                          ? Colors.greenAccent
                                          : Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  if (contact['unread'] > 0)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${contact['unread']}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.message),
        backgroundColor: Color(0xFF667eea),
      ),
    );
  }
}

// ============ TELA DE CHAT INDIVIDUAL ============
class ChatScreen extends StatefulWidget {
  final String contactName;
  final Color contactColor;

  ChatScreen({required this.contactName, required this.contactColor});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Oi! Tudo bem?',
      'time': DateTime.now().subtract(Duration(minutes: 5)),
      'isMine': false,
    },
    {
      'text': 'Tudo ótimo! E você?',
      'time': DateTime.now().subtract(Duration(minutes: 4)),
      'isMine': true,
    },
    {
      'text': 'Também! Viu o projeto que te mandei?',
      'time': DateTime.now().subtract(Duration(minutes: 3)),
      'isMine': false,
    },
  ];
  // ============================================
  // 🔥 CONFIGURAÇÃO DO CLOUDFLARE WORKERS KV 🔥
  // ============================================
  // 1. Crie um Worker no Cloudflare Dashboard (workers.cloudflare.com)
  // 2. Crie um KV Namespace chamado "CHAT_KV"
  // 3. Cole o código abaixo no seu Worker:
  /*
    export default {
      async fetch(request, env) {
        // Configurar CORS para aceitar requisições do app
        const headers = {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Content-Type': 'application/json',
        };

        // Tratar OPTIONS (CORS preflight)
        if (request.method === 'OPTIONS') {
          return new Response(null, { headers });
        }

        const url = new URL(request.url);
        
        // ENVIAR MENSAGEM (POST)
        if (request.method === 'POST') {
          const data = await request.json();
          const key = `msg_${data.timestamp}`;
          await env.CHAT_KV.put(key, JSON.stringify(data));
          return new Response(JSON.stringify({success: true}), { headers });
        }
        
        // BUSCAR MENSAGENS (GET)
        const action = url.searchParams.get('action');
        if (action === 'get') {
          const list = await env.CHAT_KV.list();
          const messages = await Promise.all(
            list.keys.map(k => env.CHAT_KV.get(k.name))
          );
          const parsed = messages.map(m => JSON.parse(m)).sort((a, b) => b.timestamp - a.timestamp);
          return new Response(JSON.stringify({messages: parsed.slice(0, 50)}), { headers });
        }
        
        return new Response(JSON.stringify({error: 'Invalid request'}), { headers, status: 400 });
      }
    }
  */
  // 4. Substitua a URL abaixo pela URL do seu Worker (ex: https://seu-worker.seu-usuario.workers.dev)
  final String _apiUrl = 'SEU_WORKER_CLOUDFLARE_URL'; // 👈 COLOQUE SUA URL AQUI!
  // ============================================
  final String _encryptionKey = 'chave_secreta_32_caracteres!!';
  Timer? _timer;
  Timer? _autoDeleteTimer;
  int _autoDeleteMinutes = 0; // 0 = desativado
  final Map<int, AnimationController> _animationControllers = {};
  Color _myBubbleColor = Color(0xFF667eea);
  Color _otherBubbleColor = Color(0xFF2d2d44);

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) => _loadMessages());
    _startAutoDeleteTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _autoDeleteTimer?.cancel();
    _controller.dispose();
    _animationControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _startAutoDeleteTimer() {
    _autoDeleteTimer?.cancel();
    if (_autoDeleteMinutes > 0) {
      _autoDeleteTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        setState(() {
          final now = DateTime.now();
          _messages.removeWhere((msg) {
            final diff = now.difference(msg['time']).inMinutes;
            return diff >= _autoDeleteMinutes;
          });
        });
      });
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1a1a2e),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.timer, color: Colors.blue),
              title: Text('Temporizador Auto-Exclusão'),
              subtitle: Text(_autoDeleteMinutes == 0 
                  ? 'Desativado' 
                  : 'Ativo: $_autoDeleteMinutes min'),
              onTap: () {
                Navigator.pop(context);
                _showAutoDeleteDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_sweep, color: Colors.red),
              title: Text('Limpar Conversa'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _messages.clear());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Conversa limpa!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.palette, color: Colors.purple),
              title: Text('Personalizar Tema'),
              onTap: () {
                Navigator.pop(context);
                _showThemeDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        title: Text('Temporizador de Auto-Exclusão'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Desativado'),
              leading: Radio<int>(
                value: 0,
                groupValue: _autoDeleteMinutes,
                onChanged: (val) {
                  setState(() => _autoDeleteMinutes = val!);
                  _startAutoDeleteTimer();
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('1 minuto'),
              leading: Radio<int>(
                value: 1,
                groupValue: _autoDeleteMinutes,
                onChanged: (val) {
                  setState(() => _autoDeleteMinutes = val!);
                  _startAutoDeleteTimer();
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('5 minutos'),
              leading: Radio<int>(
                value: 5,
                groupValue: _autoDeleteMinutes,
                onChanged: (val) {
                  setState(() => _autoDeleteMinutes = val!);
                  _startAutoDeleteTimer();
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('30 minutos'),
              leading: Radio<int>(
                value: 30,
                groupValue: _autoDeleteMinutes,
                onChanged: (val) {
                  setState(() => _autoDeleteMinutes = val!);
                  _startAutoDeleteTimer();
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('1 hora'),
              leading: Radio<int>(
                value: 60,
                groupValue: _autoDeleteMinutes,
                onChanged: (val) {
                  setState(() => _autoDeleteMinutes = val!);
                  _startAutoDeleteTimer();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    final themes = [
      {'name': 'Roxo (Padrão)', 'my': Color(0xFF667eea), 'other': Color(0xFF2d2d44)},
      {'name': 'Azul', 'my': Color(0xFF1e88e5), 'other': Color(0xFF263238)},
      {'name': 'Verde', 'my': Color(0xFF43a047), 'other': Color(0xFF2d3e2d)},
      {'name': 'Rosa', 'my': Color(0xFFec407a), 'other': Color(0xFF3e2d3a)},
      {'name': 'Laranja', 'my': Color(0xFFff7043), 'other': Color(0xFF3e2f2d)},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1a1a2e),
        title: Text('Escolher Tema das Bolhas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themes.map((theme) => ListTile(
            title: Text(theme['name'] as String),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme['my'] as Color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onTap: () {
              setState(() {
                _myBubbleColor = theme['my'] as Color;
                _otherBubbleColor = theme['other'] as Color;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  AnimationController _getAnimationController(int index) {
    if (!_animationControllers.containsKey(index)) {
      _animationControllers[index] = AnimationController(
        duration: Duration(milliseconds: 400),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [widget.contactColor, widget.contactColor.withOpacity(0.7)],
                ),
              ),
              child: Icon(Icons.person, size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.greenAccent,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('Online', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.more_vert), 
            onPressed: _showOptionsMenu,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0a0e27), Color(0xFF1a1a2e)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
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
                      curve: Curves.easeOutBack,
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
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [widget.contactColor, widget.contactColor.withOpacity(0.7)],
                                  ),
                                ),
                                child: Icon(Icons.person, size: 18, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: msg['isMine']
                                      ? LinearGradient(
                                          colors: [_myBubbleColor, _myBubbleColor.withOpacity(0.8)],
                                        )
                                      : null,
                                  color: msg['isMine'] ? null : _otherBubbleColor,
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
                                        Icon(Icons.lock, size: 10, color: Colors.white60),
                                        SizedBox(width: 4),
                                        Text(
                                          '${msg['time'].hour}:${msg['time'].minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(fontSize: 10, color: Colors.white60),
                                        ),
                                        if (msg['isMine']) ...[
                                          SizedBox(width: 4),
                                          Icon(Icons.done_all, size: 12, color: Colors.lightBlue),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (msg['isMine']) SizedBox(width: 8),
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