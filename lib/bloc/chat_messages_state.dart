import 'package:equatable/equatable.dart';

abstract class ChatMessagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatMessagesInitial extends ChatMessagesState {}

class ChatMessagesLoading extends ChatMessagesState {}

class ChatMessagesLoaded extends ChatMessagesState {
  final List<dynamic> messages;
  ChatMessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatMessagesError extends ChatMessagesState {
  final String message;
  ChatMessagesError(this.message);

  @override
  List<Object?> get props => [message];
}
