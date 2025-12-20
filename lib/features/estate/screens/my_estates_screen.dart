// lib/features/estate/screens/my_estates_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import 'package:practice_5_project/shared/cubits/auth_cubit.dart';
import '../../../shared/models/estate.dart';
import '../../../shared/widgets/estate_item.dart';

class MyEstatesScreen extends StatelessWidget {
  const MyEstatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Мои объявления')),
      body: currentUser == null
          ? const Center(child: Text('Необходимо войти в аккаунт'))
          : BlocBuilder<EstateCubit, List<Estate>>(
              builder: (context, estates) {
                final myEstates = estates
                    .where((e) => e.ownerId == currentUser.id)
                    .toList();

                if (myEstates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.home_work_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'У вас пока нет объявлений',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Создайте первое объявление',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/estate/add'),
                          icon: const Icon(Icons.add),
                          label: const Text('Добавить объявление'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Всего объявлений: ${myEstates.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/estate/add'),
                            icon: const Icon(Icons.add),
                            label: const Text('Добавить'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: myEstates.length,
                        itemBuilder: (context, index) {
                          final estate = myEstates[index];
                          return GestureDetector(
                            onTap: () => context.push('/estate/${estate.id}'),
                            child: EstateItem(estate: estate),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

