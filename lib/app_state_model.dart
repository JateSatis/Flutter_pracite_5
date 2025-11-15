// lib/app_state_model.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'shared/models/estate.dart';
import 'features/profile/models/profile.dart';

class AppStateModel with ChangeNotifier {
  final List<Estate> _estates = [
    Estate(
      id: 1,
      title: 'Квартира у метро',
      description: 'Современная 2-комнатная квартира в Москве...',
      price: 50000,
      imageUrl: 'https://chto-stoit-postroit.ru/wp-content/uploads/2024/04/1633791661_25-mykaleidoscope-ru-p-interer-pentkhausa-interer-krasivo-foto-25.jpg',
      isLiked: false,
    ),
    Estate(
      id: 2,
      title: 'Дом за городом',
      description: 'Уютный дом с участком',
      price: 120000,
      imageUrl: 'https://static35.tgcnt.ru/posts/_0/30/3040ab87e8b2614fc1d45fe173cec89f.jpg',
      isLiked: true,
    ),
    Estate(
      id: 3,
      title: 'Однушка в подмосковье',
      description: 'Дешевая квартира для студентов',
      price: 25000,
      imageUrl: 'https://media-cdn.tripadvisor.com/media/vr-splice-j/05/85/58/2b.jpg',
      isLiked: true,
    ),
  ];

  final Profile _profile = Profile(
    name: 'Максим Данилов',
    imageUrl: 'https://avatars.githubusercontent.com/u/77029208?v=4',
  );

  List<Estate> get estates => _estates;
  Profile get profile => _profile;
  List<Estate> get likedEstates => _estates.where((e) => e.isLiked).toList();

  void toggleLike(int id) {
    final estate = _estates.firstWhere((e) => e.id == id);
    estate.isLiked = !estate.isLiked;
    notifyListeners(); // ✅ триггерит DependenciesProvider
  }

  void addEstate(Estate estate) {
    _estates.add(estate);
    notifyListeners();
  }

  void deleteEstate(int id, BuildContext context) {
    final estateToDelete = _estates.firstWhere((e) => e.id == id);
    final index = _estates.indexOf(estateToDelete);
    _estates.removeAt(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Объект удалён'),
        action: SnackBarAction(
          label: 'Отмена',
          onPressed: () {
            _estates.insert(index, estateToDelete);
            notifyListeners();
          },
        ),
      ),
    );

    notifyListeners();
  }
}