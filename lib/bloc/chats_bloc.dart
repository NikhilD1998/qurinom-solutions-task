import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom/utils/constants.dart';
import 'chats_event.dart';
import 'chats_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_model.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc() : super(ChatsInitial()) {
    on<FetchChats>((event, emit) async {
      emit(ChatsLoading());
      try {
        final url = Uri.parse('${baseApiUrl}chats/user-chats/${event.userId}');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final List data = jsonDecode(response.body);
          final chats = data
              .map((json) => Chat.fromJson(json, event.userId))
              .toList();
          emit(ChatsLoaded(List<Chat>.from(chats)));
        } else {
          emit(ChatsError('Failed to load chats'));
        }
      } catch (e) {
        emit(ChatsError(e.toString()));
      }
    });
  }
}
