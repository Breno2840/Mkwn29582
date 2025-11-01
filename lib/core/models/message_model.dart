// lib/core/models/message_model.dart

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
