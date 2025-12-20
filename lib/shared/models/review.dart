class Review {
  final int id;
  final int estateId;
  final int authorId;
  final String authorName;
  final String authorAvatar;
  final String comment;
  final int rating; // от 1 до 5

  Review({
    required this.id,
    required this.estateId,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.comment,
    required this.rating,
  });

  Review copyWith({
    int? id,
    int? estateId,
    int? authorId,
    String? authorName,
    String? authorAvatar,
    String? comment,
    int? rating,
  }) {
    return Review(
      id: id ?? this.id,
      estateId: estateId ?? this.estateId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
    );
  }
}

