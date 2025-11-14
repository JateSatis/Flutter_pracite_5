// lib/features/estate/screens/estate_info_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/estate.dart';

class EstateInfoScreen extends StatelessWidget {
  final Estate estate;
  final void Function(int) onLikeEstate;
  final void Function(int) onDeleteEstate;

  const EstateInfoScreen({
    super.key,
    required this.estate,
    required this.onLikeEstate,
    required this.onDeleteEstate,
  });

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
            const SizedBox(height: 16),
            Text(estate.description),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 32),
                  onPressed: () {
                    onDeleteEstate(estate.id);
                    if (context.canPop()) context.pop();
                  },
                ),
                IconButton(
                  icon: Icon(
                    estate.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: estate.isLiked ? Colors.red : null,
                    size: 32,
                  ),
                  onPressed: () => onLikeEstate(estate.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}