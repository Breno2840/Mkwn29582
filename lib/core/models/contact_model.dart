// lib/core/models/contact_model.dart

class Contact {
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;

  Contact({
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
  });
}
