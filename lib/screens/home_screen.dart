import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom/screens/chat_screen.dart';
import 'package:qurinom/utils/helper.dart';
import '../bloc/chats_bloc.dart';
import '../bloc/chats_event.dart';
import '../bloc/chats_state.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    double screenWidth = DeviceHelper.width(context);
    double screenHeight = DeviceHelper.height(context);
    return BlocProvider(
      create: (_) => ChatsBloc()..add(FetchChats(userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chats')),
        body: BlocBuilder<ChatsBloc, ChatsState>(
          builder: (context, state) {
            if (state is ChatsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ChatsLoaded) {
              if (state.chats.isEmpty) {
                return const Center(child: Text('No chats found.'));
              }
              return ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(chatId: chat.id),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.006,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.008,
                        horizontal: screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: screenWidth * 0.06,

                          backgroundColor: Colors.green[700],
                          child: Text(
                            chat.chatName.isNotEmpty
                                ? chat.chatName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                        ),
                        title: Text(
                          chat.chatName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        subtitle: Text(
                          chat.id,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth * 0.035,
                          ),
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
    );
  }
}
