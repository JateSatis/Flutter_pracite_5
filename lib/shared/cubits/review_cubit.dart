import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/review.dart';

class ReviewCubit extends Cubit<List<Review>> {
  ReviewCubit() : super(_initialReviews);

  static final List<Review> _initialReviews = [
    Review(
      id: 1,
      estateId: 1,
      authorId: 2,
      authorName: 'Анна Петрова',
      authorAvatar: 'https://i.pravatar.cc/150?img=5',
      comment: 'Отличная квартира! Всё чисто, уютно, рядом метро.',
      rating: 5,
    ),
    Review(
      id: 2,
      estateId: 1,
      authorId: 3,
      authorName: 'Иван Сидоров',
      authorAvatar: 'https://i.pravatar.cc/150?img=12',
      comment: 'Хорошее расположение, но шумно.',
      rating: 4,
    ),
    Review(
      id: 3,
      estateId: 2,
      authorId: 1,
      authorName: 'Максим Данилов',
      authorAvatar: 'https://avatars.githubusercontent.com/u/77029208?v=4',
      comment: 'Прекрасный дом! Очень рекомендую.',
      rating: 5,
    ),
  ];

  void addReview(Review review) {
    emit([...state, review]);
  }

  List<Review> getReviewsByEstateId(int estateId) {
    return state.where((review) => review.estateId == estateId).toList();
  }
}

