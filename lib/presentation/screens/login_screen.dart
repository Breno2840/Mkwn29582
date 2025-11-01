// lib/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:app/core/services/preferences_service.dart';
import 'package:app/presentation/screens/contact_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _prefsService = PreferencesService();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _nameController.text.trim();
      await _prefsService.saveUsername(username);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ContactListScreen(username: username)),
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
                const Text('Quem é você?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Seu nome de usuário', prefixIcon: Icon(Icons.person)),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Por favor, insira um nome.' : null,
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
