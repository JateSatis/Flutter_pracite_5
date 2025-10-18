class Profile {
  final String name;
  final String imageUrl;

  Profile({required this.name, required this.imageUrl});

  Profile copyWith({
    String? name,
    String? imageUrl,
  }) {
    return Profile(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}