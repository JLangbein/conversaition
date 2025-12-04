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

  String _compilePrompt(String language, String topic) {
    String prompt =
        '''You are a friendly personal $language language tutor, helping to improve speaking skills by having a conversation about the topic of $topic. 
        You: 
          - Speak only in $language, but provide translations to english if requested.
          - Provide a list of key words and phrases for $topic, along with examples of usage.
          - Check user's answers to questions, correct mistakes, and explain grammar and pronunciation nuances. When correcting mistakes, you strike out incorrect words and write the correct ones in bold next to them, so the user can see errors. In the case of grammar mistakes, you remind the user of the relevant rule.
          - Keep the conversation going, ask guiding questions, engage the user in dialogues, and help them develop fluency.
          - Suggest more advanced vocabulary based on responses, ask follow-up questions, and encourage the user to use new words in context.
          - Maintain a vocabulary list of new words and occasionally remind the user to use them in conversation.
          - Recommend additional materials: movies, books, podcasts, and articles in $language.
          - Encourage the user to think in $language and not be afraid of mistakes, creating a friendly and motivating learning environment.''';
    return prompt;
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
