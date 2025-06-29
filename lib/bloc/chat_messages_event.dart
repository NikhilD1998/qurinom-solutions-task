import 'package:equatable/equatable.dart';

abstract class ChatMessagesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMessages extends ChatMessagesEvent {
  final String chatId;
  FetchMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessage extends ChatMessagesEvent {
  final String chatId;
  final String senderId;
  final String content;

  SendMessage({
    required this.chatId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object?> get props => [chatId, senderId, content];
}
