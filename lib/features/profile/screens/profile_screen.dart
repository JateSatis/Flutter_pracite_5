// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import 'package:practice_5_project/shared/cubits/auth_cubit.dart';
import 'package:practice_5_project/features/profile/cubits/profile_cubit.dart';
import '../../../shared/models/estate.dart';
import '../../../shared/widgets/estate_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocBuilder<EstateCubit, List<Estate>>(
        builder: (context, estates) {
          final likedEstates = estates.where((e) => e.isLiked).toList();
          final profile = context.read<ProfileCubit>().profile;

          return Scaffold(
            appBar: AppBar(title: const Text('Профиль')),
            body: ListView(
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
                      Expanded(
                        child: Text(
                          profile.name,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.home_work),
                  title: const Text('Мои объявления'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/my-estates'),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Избранное',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (likedEstates.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'Нет избранных объектов',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...likedEstates.map((estate) => EstateItem(estate: estate)),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                      context.go('/login');
                    },
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('Выйти из аккаунта'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}