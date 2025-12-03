// ignore_for_file: prefer_final_fields

import 'package:conversaition/features/chat/cubit/chat_cubit.dart';
import 'package:conversaition/features/chat/cubit/chat_state.dart';
import 'package:conversaition/features/chat/widgets/restart_warning_dialog.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.language, required this.topic});

  final String language;
  final String topic;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatUser _currentUser = ChatUser(id: '1');
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
      body: BlocConsumer<ChatCubit, ChatState>(
        // in case of Error
        listener: (context, state) {
          if (state is ChatHasError) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Something went worng'),
                content: Text(state.errorMessage),
                actions: [
                  FilledButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/welcome', (_) => false),
                    child: Text('Close'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatInitial) {
            context.read<ChatCubit>().initialize(widget.language, widget.topic);
            return Center(child: CircularProgressIndicator());
          } else if (state is ChatUpdate) {
            return DashChat(
              currentUser: _currentUser,
              typingUsers: state.typingUsers,
              onSend: (ChatMessage m) {
                context.read<ChatCubit>().getResponse(m);
              },
              messages: state.messages,
            );
          }
          return Center(child: Text('Something is off'));
        },
      ),
    );
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
