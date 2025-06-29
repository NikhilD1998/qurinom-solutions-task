import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom/bloc/login_bloc.dart';
import 'package:qurinom/utils/helper.dart';
import '../bloc/chat_messages_bloc.dart';
import '../bloc/chat_messages_event.dart';
import '../bloc/chat_messages_state.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late ChatMessagesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChatMessagesBloc()..add(FetchMessages(widget.chatId));
  }

  void sendMessage(String content) {
    final senderId = BlocProvider.of<LoginBloc>(
      context,
      listen: false,
    ).state.userId;
    if (senderId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in!')));
      return;
    }
    _bloc.add(
      SendMessage(chatId: widget.chatId, senderId: senderId, content: content),
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = DeviceHelper.width(context);
    double screenHeight = DeviceHelper.height(context);
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
                builder: (context, state) {
                  if (state is ChatMessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatMessagesError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is ChatMessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return const Center(child: Text('No messages found.'));
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg =
                            state.messages[state.messages.length - 1 - index];
                        final isMe =
                            msg['senderId'] ==
                            BlocProvider.of<LoginBloc>(
                              context,
                              listen: false,
                            ).state.userId;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.005,
                              horizontal: screenWidth * 0.02,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.012,
                              horizontal: screenWidth * 0.04,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xFF62A30E)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 16),
                              ),
                            ),
                            child: Text(
                              msg['content'] ?? '',
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontSize:
                                    screenWidth * 0.042, // Responsive font
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(fontSize: screenWidth * 0.045),

                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ), // Rounded border
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ), // Rounded border
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ), // Rounded border
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),

                  IconButton(
                    icon: Icon(Icons.send, size: screenWidth * 0.07),
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        sendMessage(text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
