class Chat {
  final int id;
  final int estateId;
  final String estateTitle;
  final int ownerId;
  final String ownerName;
  final String ownerAvatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  Chat({
    required this.id,
    required this.estateId,
    required this.estateTitle,
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatar,
    this.lastMessage,
    this.lastMessageTime,
  });

  Chat copyWith({
    int? id,
    int? estateId,
    String? estateTitle,
    int? ownerId,
    String? ownerName,
    String? ownerAvatar,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return Chat(
      id: id ?? this.id,
      estateId: estateId ?? this.estateId,
      estateTitle: estateTitle ?? this.estateTitle,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerAvatar: ownerAvatar ?? this.ownerAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}

