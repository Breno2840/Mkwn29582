// lib/core/services/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app/core/models/message_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
      CREATE TABLE messages ( 
        id $idType, 
        chatId $textType,
        sender $textType,
        encryptedContent $textType,
        timestamp $textType
      )
    ''');
  }

  Future<void> insertMessage(Message message, String chatId) async {
    final db = await instance.database;
    await db.insert('messages', {
      'chatId': chatId,
      'sender': message.sender,
      'encryptedContent': message.encryptedContent,
      'timestamp': message.timestamp.toIso8601String(),
    });
  }

  Future<List<Message>> getMessages(String chatId) async {
    final db = await instance.database;
    final maps = await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((json) => Message(
      sender: json['sender'] as String,
      encryptedContent: json['encryptedContent'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    )).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
