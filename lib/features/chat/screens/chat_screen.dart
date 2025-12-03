// ignore_for_file: prefer_final_fields

import 'package:conversaition/features/chat/widgets/restart_warning_dialog.dart';
import 'package:conversaition/features/welcome_screen/welcome_screen.dart';
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
      appBar: AppBar(
        centerTitle: false,
        primary: true,
        title: Text('${widget.topic} - ${widget.language}'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
            child: FilledButton.tonalIcon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => RestartWarningDialog(restart: _restart),
                );
              },
              label: Text('Restart'),
              icon: Icon(Icons.restart_alt_rounded),
            ),
          ),
        ],
      ),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        onSend: (ChatMessage m) {
          getResponse(m);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_chatGptUser);
    });
    debugPrint(m.text);
    await Future.delayed(Duration(milliseconds: 500));
    final ChatMessage response = ChatMessage(
      user: _chatGptUser,
      createdAt: DateTime.now(),
      text: 'Repsonse to ${m.text}',
    );
    setState(() {
      _messages.insert(0, response);
      _typingUsers.clear();
    });
  }

  Future<void> _restart() async {
    await Future.delayed(Duration(microseconds: 1000));
    setState(() {
      _messages.clear();
    });
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (_) => false);
    }
  }
}
