import 'package:conversaition/features/chat/cubit/chat_state.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  // Handing over the initial State of Chat
  ChatCubit() : super(ChatInitial());

  final List<ChatMessage> _messages = [];

  final ChatUser _chatGptUser = ChatUser(
    id: '2',
    firstName: 'Chad',
    lastName: 'Gpt',
  );

  final List<ChatUser> _typingUsers = [];

  ChatUser get chatGptUser => _chatGptUser;
  List<ChatUser> get typingUsers => _typingUsers;
  List<ChatMessage> get messages => _messages;

  Future<void> initialize(String language, String topic) async {
    await Future.delayed(Duration(milliseconds: 500));
    emit(ChatUpdate(_messages, _typingUsers));
  }

  Future<void> getResponse(ChatMessage m) async {
    _messages.insert(0, m);
    _typingUsers.add(_chatGptUser);
    emit(ChatUpdate(_messages, _typingUsers));

    await Future.delayed(Duration(milliseconds: 500));

    final ChatMessage response = ChatMessage(
      user: _chatGptUser,
      createdAt: DateTime.now(),
      text: 'Repsonse to ${m.text}',
    );

    _typingUsers.clear();
    _messages.insert(0, response);
    emit(ChatUpdate(_messages, _typingUsers));
  }
}
