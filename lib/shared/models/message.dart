class Message {
  final int id;
  final int chatId;
  final int senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  Message copyWith({
    int? id,
    int? chatId,
    int? senderId,
    String? senderName,
    String? text,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

