// absctract state to be extended by all other states
import 'package:dash_chat_2/dash_chat_2.dart';

abstract class ChatState {
  const ChatState();
}

// Initial State
class ChatInitial extends ChatState {
  const ChatInitial();
}

// Chat Updated
class ChatUpdate extends ChatState {
  final List<ChatMessage> messages;
  final List<ChatUser> typingUsers;
  const ChatUpdate(this.messages, this.typingUsers);
}

// has Error
class ChatHasError extends ChatState {
  final String errorMessage;
  const ChatHasError(this.errorMessage);
}
