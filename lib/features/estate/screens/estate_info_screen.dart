// lib/features/estate/screens/estate_info_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import 'package:practice_5_project/shared/cubits/chat_cubit.dart';
import 'package:practice_5_project/shared/cubits/auth_cubit.dart';
import 'package:practice_5_project/shared/models/chat.dart';
import 'package:practice_5_project/shared/models/estate.dart';
import 'package:url_launcher/url_launcher.dart';

class EstateInfoScreen extends StatelessWidget {
  final Estate estate;

  const EstateInfoScreen({
    super.key,
    required this.estate,
  });

  Map<String, String> _getOwnerData(int ownerId) {
    // Мокапные данные владельцев
    final owners = {
      1: {'name': 'Максим Данилов', 'avatar': 'https://avatars.githubusercontent.com/u/77029208?v=4'},
      2: {'name': 'Анна Петрова', 'avatar': 'https://i.pravatar.cc/150?img=5'},
      3: {'name': 'Иван Сидоров', 'avatar': 'https://i.pravatar.cc/150?img=12'},
    };
    
    final owner = owners[ownerId] ?? {'name': 'Владелец $ownerId', 'avatar': 'https://i.pravatar.cc/150?img=$ownerId'};
    return owner;
  }

  void _onWriteOwner(BuildContext context) {
    final currentUser = context.read<AuthCubit>().currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Необходимо войти в аккаунт')),
      );
      return;
    }

    final chatCubit = context.read<ChatCubit>();
    final existingChat = chatCubit.getChatByEstateId(estate.id);

    if (existingChat != null) {
      context.push('/chat/${existingChat.id}');
    } else {
      // Создаем новый чат
      final ownerData = _getOwnerData(estate.ownerId);
      final newChat = Chat(
        id: DateTime.now().millisecondsSinceEpoch,
        estateId: estate.id,
        estateTitle: estate.title,
        ownerId: estate.ownerId,
        ownerName: ownerData['name']!,
        ownerAvatar: ownerData['avatar']!,
      );

      chatCubit.addChat(newChat);
      context.push('/chat/${newChat.id}');
    }
  }

  Widget _buildMapWidget() {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(
          'https://yandex.ru/maps/?pt=${estate.longitude},${estate.latitude}&z=15',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    '${estate.latitude.toStringAsFixed(4)}, ${estate.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Нажмите, чтобы открыть карту',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.open_in_new, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(fullStars, (index) => const Icon(Icons.star, color: Colors.amber, size: 20)),
        if (hasHalfStar) const Icon(Icons.star_half, color: Colors.amber, size: 20),
        ...List.generate(5 - fullStars - (hasHalfStar ? 1 : 0), (index) => const Icon(Icons.star_border, color: Colors.amber, size: 20)),
        const SizedBox(width: 8),
        Text('${rating.toStringAsFixed(1)} (${estate.reviewsAmount})'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Информация')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: estate.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              estate.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${estate.price} ₽/мес', style: const TextStyle(fontSize: 20)),
            if (estate.reviewsAmount > 0) ...[
              const SizedBox(height: 8),
              _buildRatingStars(estate.averageRating),
            ],
            const SizedBox(height: 16),
            Text(estate.description),
            const SizedBox(height: 24),
            const Text(
              'Местоположение',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildMapWidget(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _onWriteOwner(context),
                icon: const Icon(Icons.message),
                label: const Text('Написать владельцу'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/estate/${estate.id}/reviews'),
                icon: const Icon(Icons.star),
                label: const Text('Посмотреть отзывы'),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 32),
                  onPressed: () {
                    context.read<EstateCubit>().deleteEstate(estate.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Объект удалён')),
                    );
                    if (context.canPop()) context.pop();
                  },
                ),
                IconButton(
                  icon: Icon(
                    estate.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: estate.isLiked ? Colors.red : null,
                    size: 32,
                  ),
                  onPressed: () => context.read<EstateCubit>().toggleLike(estate.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}