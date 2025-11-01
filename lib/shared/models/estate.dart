class Estate {
  final int id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  bool isLiked;

  Estate({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isLiked,
  });

  Estate copyWith({
    int? id,
    String? title,
    String? description,
    int? price,
    String? imageUrl,
    bool? isLiked,
  }) {
    return Estate(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

