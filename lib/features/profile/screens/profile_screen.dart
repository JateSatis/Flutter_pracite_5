// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../../../shared/models/estate.dart';
import '../../../shared/widgets/estate_item.dart';
import '../../../app_dependencies.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = DependenciesProvider.of(context);
    final likedEstates = model.likedEstates;
    final profile = model.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: likedEstates.isEmpty
          ? const Center(child: Text('Нет избранных объектов'))
          : ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    profile.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80),
                  ),
                ),
                const SizedBox(width: 16),
                Text(profile.name, style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Избранное', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...likedEstates.map((estate) => EstateItem(estate: estate)),
        ],
      ),
    );
  }
}