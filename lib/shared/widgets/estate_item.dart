import 'package:flutter/material.dart';
import '../models/estate.dart';

class EstateItem extends StatelessWidget {
  final Estate estate;
  final void Function(int) onLikeEstate;
  final void Function(int) onDeleteEstate;

  const EstateItem({
    super.key,
    required this.estate,
    required this.onLikeEstate,
    required this.onDeleteEstate,
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
            child: Image.network(
              estate.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
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
                  onPressed: () => onDeleteEstate(estate.id),
                ),
                IconButton(
                  icon: Icon(
                    estate.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: estate.isLiked ? Colors.red : null,
                    size: 24,
                  ),
                  onPressed: () => onLikeEstate(estate.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}