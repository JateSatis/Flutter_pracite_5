// lib/shared/widgets/estate_item.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import '../models/estate.dart';

class EstateItem extends StatelessWidget {
  final Estate estate;

  const EstateItem({
    super.key,
    required this.estate,
  });

  @override
  Widget build(BuildContext context) {
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
                    context.read<EstateCubit>().deleteEstate(estate.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Объект удалён')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    estate.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: estate.isLiked ? Colors.red : null,
                    size: 24,
                  ),
                  onPressed: () => context.read<EstateCubit>().toggleLike(estate.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}