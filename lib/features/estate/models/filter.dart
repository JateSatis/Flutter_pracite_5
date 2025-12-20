class Filter {
  final String? title;
  final int? minPrice;
  final int? maxPrice;
  final double? minRating;

  Filter({this.title, this.minPrice, this.maxPrice, this.minRating});

  Filter copyWith({
    String? title,
    int? minPrice,
    int? maxPrice,
    double? minRating,
  }) {
    return Filter(
      title: title ?? this.title,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
    );
  }
}