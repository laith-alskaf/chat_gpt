import 'dart:convert';
import 'package:chatgpt_laith/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStorage {
  static const String storageKey = 'chat_messages';

  static Future<void> saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedMessages =
        messages.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList(storageKey, encodedMessages);
  }

  static Future<List<Message>> retrieveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedMessages = prefs.getStringList(storageKey);

    if (encodedMessages != null) {
      final messages = encodedMessages.map((m) {
        final decodedMap = json.decode(m);
        return Message.fromJson(decodedMap);
      }).toList();
      return messages;
    }
    return [];
  }
}
