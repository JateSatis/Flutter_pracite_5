import 'package:flutter/material.dart';
import 'package:practice_5_project/features/profile/models/profile.dart';
import '../../../shared/models/estate.dart';
import '../../../shared/widgets/estate_item.dart';

class ProfileScreen extends StatelessWidget {
  final Profile profile;
  final List<Estate> likedEstates;
  final void Function(int) onLikeEstate;
  final void Function(int) onDeleteEstate;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.likedEstates,
    required this.onLikeEstate,
    required this.onDeleteEstate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profile.imageUrl),
                ),
                const SizedBox(width: 16),
                Text(
                  profile.name,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Избранное',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...likedEstates.map(
                (estate) => EstateItem(
              estate: estate,
              onLikeEstate: onLikeEstate,
              onDeleteEstate: onDeleteEstate,
            ),
          ),
          if (likedEstates.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Нет избранных объектов'),
            ),
        ],
      ),
    );
  }
}