import 'package:equatable/equatable.dart';

abstract class ChatsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchChats extends ChatsEvent {
  final String userId;
  FetchChats(this.userId);

  @override
  List<Object?> get props => [userId];
}
