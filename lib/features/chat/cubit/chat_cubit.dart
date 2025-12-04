// as chat_gpt to not confuse Message from dash_chat and Messages from
// chat_gpt_skd and more
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart' as chat_gpt;
import 'package:conversaition/const.dart';
import 'package:conversaition/features/chat/cubit/chat_state.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  // Handing over the initial State of Chat
  ChatCubit() : super(ChatInitial());

  // The displayed Chat Messages (reversed order)
  final List<ChatMessage> _messages = [];

  // The 2nd User aka Chad GPT
  final ChatUser _chatGptUser = ChatUser(
    id: '2',
    firstName: 'Chad',
    lastName: 'Gpt',
  );

  // To show that someone's typing
  final List<ChatUser> _typingUsers = [];

  // The openAI ChatGPT instance
  final openAI = chat_gpt.OpenAI.instance.build(
    token: openAiKey,
    baseOption: chat_gpt.HttpSetup(receiveTimeout: const Duration(seconds: 5)),
  );

  Future<void> initialize(String language, String topic) async {
    // Create the Language Tutor Assistant
    final assistant = chat_gpt.Assistant(
      model: chat_gpt.Gpt4AModel(),
      name: '$language Tutor',
      instructions: _compilePrompt(language, topic),
    );
    try {
      await openAI.assistant.v2.create(assistant: assistant);
    } catch (e) {
      emit(ChatHasError('$e'));
    }

    // Show ChatGPT as typing
    _typingUsers.add(_chatGptUser);
    emit(ChatUpdate(_messages, _typingUsers));

    // Send initial message
    final request = chat_gpt.ChatCompleteText(
      model: chat_gpt.Gpt4oMini2024ChatModel(),
      messages: [
        chat_gpt.Messages(
          role: chat_gpt.Role.user,
          content:
              '''Give yourself a name in $language and introduce yourself.
              Ask the user for their name.
              Ask the user if they want to further narrow down the topic of $topic.
              ''',
        ).toJson(),
      ],
      maxToken: 1000,
    );

    try {
      // Awaiting the reponse, check its choices for non-null messages
      // and add them to the Message list of the chat
      final response = await openAI.onChatCompletion(request: request);
      for (var element in response!.choices) {
        if (element.message != null) {
          _messages.insert(
            0,
            ChatMessage(
              user: _chatGptUser,
              createdAt: DateTime.now(),
              text: element.message!.content,
            ),
          );
        }
      }
    } catch (e) {
      emit(ChatHasError('$e'));
    }

    // Show ChatGPT as no longer tying
    _typingUsers.clear();

    // Show Chad's introduction message
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
          - Regularly summarize the conversation in a short and consise paragraph.
          - Recommend additional materials: movies, books, podcasts, and articles in $language.
          - Encourage the user to think in $language and not be afraid of mistakes, creating a friendly and motivating learning environment.''';
    return prompt;
  }

  Future<void> getResponse(ChatMessage m) async {
    // Add the user's message to chat
    _messages.insert(0, m);
    // set Chad as typing
    _typingUsers.add(_chatGptUser);
    emit(ChatUpdate(_messages, _typingUsers));

    // create request
    // list of chat messages needs to be inversed
    // Message.user needs to be transfered to either Role.assistant or Role.user
    List<Map<String, dynamic>> chatHistory = _messages.reversed.map((m) {
      if (m.user == _chatGptUser) {
        return chat_gpt.Messages(
          role: chat_gpt.Role.assistant,
          content: m.text,
        ).toJson();
      } else {
        return chat_gpt.Messages(
          role: chat_gpt.Role.user,
          content: m.text,
        ).toJson();
      }
    }).toList();

    final request = chat_gpt.ChatCompleteText(
      model: chat_gpt.Gpt4oMini2024ChatModel(),
      messages: chatHistory,
      maxToken: 1000,
    );

    try {
      // Awaiting the reponse, check its choices for non-null messages
      // and add them to the Message list of the chat
      final response = await openAI.onChatCompletion(request: request);
      for (var element in response!.choices) {
        if (element.message != null) {
          _messages.insert(
            0,
            ChatMessage(
              user: _chatGptUser,
              createdAt: DateTime.now(),
              text: element.message!.content,
            ),
          );
        }
      }
    } catch (e) {
      emit(ChatHasError('$e'));
    }

    // Show ChatGPT as no longer tying
    _typingUsers.clear();

    // Show Chad's introduction message
    emit(ChatUpdate(_messages, _typingUsers));

    final reque2t = chat_gpt.ThreadRequest(
      messages: [
        {
          "role": "user",
          "content": "Hello, what is AI?",
          "file_ids": ["file-abc123"],
        },
        {
          "role": "user",
          "content": "How does AI work? Explain it in simple terms.",
        },
      ],
    );

    await openAI.threads.v2.createThread(request: reque2t);
  }
}
