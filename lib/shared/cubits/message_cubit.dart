import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/message.dart';

class MessageCubit extends Cubit<List<Message>> {
  MessageCubit() : super(_initialMessages);

  static final List<Message> _initialMessages = [
    Message(
      id: 1,
      chatId: 1,
      senderId: 2,
      senderName: 'Анна Петрова',
      text: 'Здравствуйте! Интересует ваша квартира.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Message(
      id: 2,
      chatId: 1,
      senderId: 1,
      senderName: 'Максим Данилов',
      text: 'Здравствуйте! Да, квартира свободна.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    Message(
      id: 3,
      chatId: 2,
      senderId: 1,
      senderName: 'Максим Данилов',
      text: 'Можно посмотреть дом в выходные?',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void addMessage(Message message) {
    emit([...state, message]);
  }

  List<Message> getMessagesByChatId(int chatId) {
    return state.where((message) => message.chatId == chatId).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}

