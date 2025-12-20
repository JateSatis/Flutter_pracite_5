// lib/features/chat/screens/chat_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/chat_cubit.dart';
import 'package:practice_5_project/shared/cubits/message_cubit.dart';
import 'package:practice_5_project/shared/cubits/auth_cubit.dart';
import 'package:practice_5_project/shared/models/chat.dart';
import 'package:practice_5_project/shared/models/message.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;

  const ChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final currentUser = context.read<AuthCubit>().currentUser;
    if (currentUser == null) return;

    final chat = context.read<ChatCubit>().state.firstWhere(
          (c) => c.id == widget.chatId,
        );

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      chatId: widget.chatId,
      senderId: currentUser.id,
      senderName: currentUser.name,
      text: text,
      timestamp: DateTime.now(),
    );

    context.read<MessageCubit>().addMessage(newMessage);
    context.read<ChatCubit>().updateChatLastMessage(widget.chatId, text);

    _messageController.clear();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatCubit>().state.firstWhere(
          (c) => c.id == widget.chatId,
        );
    final currentUser = context.read<AuthCubit>().currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: chat.ownerAvatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.person, size: 40),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.estateTitle,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    chat.ownerName,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageCubit, List<Message>>(
              builder: (context, messages) {
                final chatMessages = context
                    .read<MessageCubit>()
                    .getMessagesByChatId(widget.chatId);

                if (chatMessages.isEmpty) {
                  return const Center(child: Text('Нет сообщений'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = chatMessages[index];
                    final isOwnMessage =
                        currentUser != null && message.senderId == currentUser.id;

                    return Align(
                      alignment: isOwnMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isOwnMessage ? Colors.green[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isOwnMessage)
                              Text(
                                message.senderName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            Text(message.text),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Введите сообщение',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

