// as chat_gpt to not confuse Message from dash_chat and Messages from
// chat_gpt_skd and more
// ignore_for_file: prefer_final_fields

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart' as chat_gpt;
import 'package:conversaition/const.dart';
import 'package:conversaition/features/chat/cubit/chat_state.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  // Handing over the initial State of Chat
  ChatCubit() : super(ChatInitial());

  // The displayed Chat Messages (reversed order)
  List<ChatMessage> _messages = [];

  // The 2nd User aka Chad GPT
  final ChatUser _chatGptUser = ChatUser(
    id: '2',
    firstName: 'Chad',
    lastName: 'Gpt',
  );

  // To show that someone's typing
  List<ChatUser> _typingUsers = [];

  // The openAI ChatGPT instance
  final openAI = chat_gpt.OpenAI.instance.build(
    token: openAiKey,
    baseOption: chat_gpt.HttpSetup(receiveTimeout: const Duration(seconds: 5)),
  );

  // the chat_gpt assistant
  late chat_gpt.AssistantData assistantData;

  // the chatGPT thread
  late chat_gpt.ThreadResponse threadResponse;

  // To start the whole thing off we create an assistant and a thread
  // give an initial message and run the whole damn thing
  Future<void> initialize(String language, String topic) async {
    // Create the Language Tutor Assistant and retrieve its info
    final assistant = chat_gpt.Assistant(
      model: chat_gpt.Gpt4AModel(),
      name: '$language Tutor',
      instructions: _compilePrompt(language, topic),
    );

    try {
      assistantData = await openAI.assistant.v2.create(assistant: assistant);
    } catch (e) {
      emit(ChatHasError('$e'));
    }

    // Show ChatGPT as typing
    _typingUsers.add(_chatGptUser);
    emit(ChatUpdate(_messages, _typingUsers));

    // create the thread and retrieve its info

    try {
      threadResponse = await openAI.threads.v2.createThread(
        request: chat_gpt.ThreadRequest(),
      );
    } catch (e) {
      emit(ChatHasError('$e'));
    }

    // send initial message to thread
    final request = chat_gpt.CreateMessage(
      role: 'user',
      content:
          '''Give yourself a name in $language and introduce yourself.
        Ask the user for their name.
        Ask the user if they want to further narrow down the topic of $topic.
      ''',
    );

    // sending message to thread
    await openAI.threads.v2.messages.createMessage(
      threadId: threadResponse.id,
      request: request,
    );

    // run the run
    final run = chat_gpt.CreateRun(assistantId: assistantData.id);

    // the run info to be stored
    late chat_gpt.CreateRunResponse runResponse;
    try {
      runResponse = await openAI.threads.v2.runs.createRun(
        threadId: threadResponse.id,
        request: run,
      );
    } catch (e) {
      emit(ChatHasError('$e'));
    }

    // check if the run completes successfully
    late chat_gpt.CreateRunResponse runStatus;
    do {
      await Future.delayed(Duration(milliseconds: 200));
      runStatus = await openAI.threads.v2.runs.retrieveRun(
        threadId: threadResponse.id,
        runId: runResponse.id,
      );
    } while (runStatus.status != 'completed' && runStatus.status != 'failed');

    // Finally retrieve the message the assistant created from the thread and
    // add to the chat history
    try {
      final responsesList = await openAI.threads.v2.messages.listMessage(
        threadId: threadResponse.id,
      );
      final response = responsesList.data.firstWhere(
        (m) => m.role == 'assistant' && m.runId == runResponse.id,
      );

      for (var element in response.content) {
        if (element.text != null) {
          _messages.insert(
            0,
            ChatMessage(
              user: _chatGptUser,
              createdAt: DateTime.now(),
              text: element.text!.value,
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

  // helper function for the assistant's instructions
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

  // fundamental function for the chat
  // inserts the user's message in the thread, runs it and retrieves the
  // response
  Future<void> getResponse(ChatMessage m) async {
    // Add the user's message to chat
    _messages.insert(0, m);
    // set Chad as typing
    _typingUsers.add(_chatGptUser);
    emit(ChatUpdate(_messages, _typingUsers));

    // send initial message to thread
    final request = chat_gpt.CreateMessage(role: 'user', content: m.text);

    // sending message to thread
    await openAI.threads.v2.messages.createMessage(
      threadId: threadResponse.id,
      request: request,
    );

    // run the run
    final run = chat_gpt.CreateRun(assistantId: assistantData.id);

    // the run info to be stored
    late chat_gpt.CreateRunResponse runResponse;
    try {
      runResponse = await openAI.threads.v2.runs.createRun(
        threadId: threadResponse.id,
        request: run,
      );
    } catch (e) {
      emit(ChatHasError('$e'));
    }

    // check if the run completes successfully
    late chat_gpt.CreateRunResponse runStatus;
    do {
      await Future.delayed(Duration(milliseconds: 200));
      runStatus = await openAI.threads.v2.runs.retrieveRun(
        threadId: threadResponse.id,
        runId: runResponse.id,
      );
    } while (runStatus.status != 'completed' && runStatus.status != 'failed');

    // Finally retrieve the message the assistant created from the thread and
    // add to the chat history
    try {
      final responsesList = await openAI.threads.v2.messages.listMessage(
        threadId: threadResponse.id,
      );
      final response = responsesList.data.firstWhere(
        (m) => m.role == 'assistant' && m.runId == runResponse.id,
      );

      for (var element in response.content) {
        if (element.text != null) {
          _messages.insert(
            0,
            ChatMessage(
              user: _chatGptUser,
              createdAt: DateTime.now(),
              text: element.text!.value,
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

  // to delete the assistant and thread on restart 
  Future<void> deleteThread() async {
    await openAI.assistant.v2.delete(assistantId: assistantData.id);
    await openAI.threads.v2.deleteThread(threadId: threadResponse.id);
    emit(ChatInitial());
  }
}
