// lib/repositories/profile_repository.dart
import '../features/profile/models/profile.dart';

class ProfileRepository {
  final Profile _profile = Profile(
    name: 'Максим Данилов',
    imageUrl: 'https://avatars.githubusercontent.com/u/77029208?v=4',
  );

  Profile get profile => _profile;
}