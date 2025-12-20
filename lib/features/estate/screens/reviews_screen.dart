// lib/features/estate/screens/reviews_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/review_cubit.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import 'package:practice_5_project/shared/cubits/auth_cubit.dart';
import 'package:practice_5_project/shared/models/review.dart';

class ReviewsScreen extends StatefulWidget {
  final int estateId;

  const ReviewsScreen({
    super.key,
    required this.estateId,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _commentController = TextEditingController();
  int _selectedRating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onAddReview() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите комментарий')),
      );
      return;
    }

    final currentUser = context.read<AuthCubit>().currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Необходимо войти в аккаунт')),
      );
      return;
    }

    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch,
      estateId: widget.estateId,
      authorId: currentUser.id,
      authorName: currentUser.name,
      authorAvatar: currentUser.avatarUrl,
      comment: comment,
      rating: _selectedRating,
    );

    context.read<ReviewCubit>().addReview(newReview);
    context.read<EstateCubit>().updateEstateRating(widget.estateId, _selectedRating);
    
    _commentController.clear();
    _selectedRating = 5;
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отзыв добавлен')),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отзывы')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ReviewCubit, List<Review>>(
              builder: (context, reviews) {
                final estateReviews = reviews
                    .where((r) => r.estateId == widget.estateId)
                    .toList()
                  ..sort((a, b) => b.id.compareTo(a.id));

                if (estateReviews.isEmpty) {
                  return const Center(child: Text('Пока нет отзывов'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: estateReviews.length,
                  itemBuilder: (context, index) {
                    final review = estateReviews[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: review.authorAvatar,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.person, size: 50),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.authorName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _buildStarRating(review.rating),
                                  const SizedBox(height: 8),
                                  Text(review.comment),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Введите комментарий',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onAddReview,
                    child: const Text('Добавить отзыв'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

