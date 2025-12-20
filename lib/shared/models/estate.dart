class Estate {
  final int id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  bool isLiked;
  final double latitude;
  final double longitude;
  final int ownerId;
  int totalStars;
  int reviewsAmount;

  Estate({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isLiked,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    this.totalStars = 0,
    this.reviewsAmount = 0,
  });

  double get averageRating => reviewsAmount > 0 ? totalStars / reviewsAmount : 0.0;

  Estate copyWith({
    int? id,
    String? title,
    String? description,
    int? price,
    String? imageUrl,
    bool? isLiked,
    double? latitude,
    double? longitude,
    int? ownerId,
    int? totalStars,
    int? reviewsAmount,
  }) {
    return Estate(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isLiked: isLiked ?? this.isLiked,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ownerId: ownerId ?? this.ownerId,
      totalStars: totalStars ?? this.totalStars,
      reviewsAmount: reviewsAmount ?? this.reviewsAmount,
    );
  }
}

