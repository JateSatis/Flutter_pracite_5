import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat.dart';

class ChatCubit extends Cubit<List<Chat>> {
  ChatCubit() : super(_initialChats);

  static final List<Chat> _initialChats = [
    Chat(
      id: 1,
      estateId: 1,
      estateTitle: 'Квартира у метро',
      ownerId: 1,
      ownerName: 'Максим Данилов',
      ownerAvatar: 'https://avatars.githubusercontent.com/u/77029208?v=4',
      lastMessage: 'Здравствуйте! Интересует ваша квартира.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Chat(
      id: 2,
      estateId: 2,
      estateTitle: 'Дом за городом',
      ownerId: 2,
      ownerName: 'Анна Петрова',
      ownerAvatar: 'https://i.pravatar.cc/150?img=5',
      lastMessage: 'Можно посмотреть дом в выходные?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void addChat(Chat chat) {
    final existingChat = state.firstWhere(
      (c) => c.estateId == chat.estateId,
      orElse: () => chat.copyWith(id: -1),
    );
    if (existingChat.id == -1) {
      emit([...state, chat]);
    }
  }

  void updateChatLastMessage(int chatId, String message) {
    final chats = List<Chat>.from(state);
    final index = chats.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      chats[index] = chats[index].copyWith(
        lastMessage: message,
        lastMessageTime: DateTime.now(),
      );
      emit(chats);
    }
  }

  Chat? getChatByEstateId(int estateId) {
    try {
      return state.firstWhere((chat) => chat.estateId == estateId);
    } catch (e) {
      return null;
    }
  }
}

