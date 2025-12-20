// lib/features/chat/screens/chat_list_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/chat_cubit.dart';
import 'package:practice_5_project/shared/models/chat.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  void _navigateToChat(BuildContext context, Chat chat) {
    context.push('/chat/${chat.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чаты')),
      body: BlocBuilder<ChatCubit, List<Chat>>(
        builder: (context, chats) {
          if (chats.isEmpty) {
            return const Center(child: Text('Нет чатов'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: chat.ownerAvatar,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.person, size: 50),
                    ),
                  ),
                  title: Text(
                    chat.estateTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chat.ownerName),
                  trailing: chat.lastMessage != null
                      ? Text(
                          chat.lastMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: () => _navigateToChat(context, chat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

