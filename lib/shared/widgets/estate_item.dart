// lib/shared/widgets/estate_item.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:practice_5_project/estate_repository.dart';
import '../models/estate.dart';
import '../../di_container.dart';

class EstateItem extends StatelessWidget {
  final Estate estate;

  const EstateItem({
    super.key,
    required this.estate,
  });

  @override
  Widget build(BuildContext context) {
    final estateRepo = getIt.get<EstateRepository>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: estate.imageUrl,
              height: 120,
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estate.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('${estate.price} ₽/мес'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 24),
                  onPressed: () {
                    estateRepo.deleteEstate(estate.id, () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Объект удалён'),
                          action: SnackBarAction(
                            label: 'Отмена',
                            onPressed: () {
                              estateRepo.estates.insert(
                                estateRepo.estates.length,
                                estate,
                              );
                              estate.isLiked = !estate.isLiked;
                              estate.isLiked = !estate.isLiked;
                            },
                          ),
                        ),
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    estate.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: estate.isLiked ? Colors.red : null,
                    size: 24,
                  ),
                  onPressed: () => estateRepo.toggleLike(estate.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}