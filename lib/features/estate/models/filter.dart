class Filter {
  final String? title;
  final int? minPrice;
  final int? maxPrice;

  Filter({this.title, this.minPrice, this.maxPrice});

  Filter copyWith({
    String? title,
    int? minPrice,
    int? maxPrice,
  }) {
    return Filter(
      title: title ?? this.title,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}