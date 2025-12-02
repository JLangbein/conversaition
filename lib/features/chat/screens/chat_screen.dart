import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.language, required this.topic});

  final String language;
  final String topic;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatUser _currentUser = ChatUser(id: '1');
  final ChatUser _chatGptUser = ChatUser(
    id: '2',
    firstName: 'Chad',
    lastName: 'Gpt',
  );
  List<ChatUser> _typingUsers = [];
  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text')),
      body: DashChat(
        currentUser: _currentUser,
        onSend: (ChatMessage m) {
          getResponse(m);
          setState(() {
            _messages.insert(0, m);
          });
        },
        messages: _messages,
      ),
    );
  }
}

Future<void> getResponse(ChatMessage m) async {
  debugPrint(m.text);
}
