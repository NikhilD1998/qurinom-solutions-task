import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:qurinom/utils/constants.dart';
import 'chat_messages_event.dart';
import 'chat_messages_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  IO.Socket? socket;
  List<dynamic> _messages = [];

  ChatMessagesBloc() : super(ChatMessagesInitial()) {
    on<FetchMessages>((event, emit) async {
      emit(ChatMessagesLoading());
      try {
        final url = Uri.parse(
          '${baseApiUrl}messages/get-messagesformobile/${event.chatId}',
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          _messages = jsonDecode(response.body);
        } else {
          _messages = [];
        }

        emit(ChatMessagesLoaded(_messages));

        socket = IO.io(
          baseApiUrl,
          IO.OptionBuilder().setTransports(['websocket']).setQuery({
            'userId': '673d80bc2330e08c323f4393',
          }).build(),
        );
        socket!.connect();

        socket!.on('message', (data) {
          _messages.add(data);
          add(_NewMessageReceived(_messages));
        });
      } catch (e) {
        emit(ChatMessagesError(e.toString()));
      }
    });

    on<_NewMessageReceived>((event, emit) {
      emit(ChatMessagesLoaded(List.from(event.messages)));
    });

    on<SendMessage>((event, emit) async {
      try {
        final url = Uri.parse('${baseApiUrl}messages/sendMessage');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'chatId': event.chatId,
            'senderId': event.senderId,
            'content': event.content,
            "messageType": "text",
            "fileUrl": "",
          }),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          add(FetchMessages(event.chatId));
        } else {
          emit(ChatMessagesError('Failed to send message: ${response.body}'));
        }
      } catch (e) {
        emit(ChatMessagesError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    socket?.dispose();
    return super.close();
  }
}

class _NewMessageReceived extends ChatMessagesEvent {
  final List<dynamic> messages;
  _NewMessageReceived(this.messages);

  @override
  List<Object?> get props => [messages];
}
