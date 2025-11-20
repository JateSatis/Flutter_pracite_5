import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/models/estate.dart';

class EstateCubit extends Cubit<List<Estate>> {
  EstateCubit() : super(_initialEstates);

  static final List<Estate> _initialEstates = [
    Estate(
      id: 1,
      title: 'Квартира у метро',
      description: 'Современная 2-комнатная квартира в Москве, расположенная в шаговой доступности от станции метро, предлагает идеальное сочетание удобства и комфорта для городской жизни. Просторные светлые комнаты с качественным ремонтом, функциональная кухня-гостиная и продуманная планировка создают уютную атмосферу, а близость к транспорту, магазинам и парковой зоне делает проживание максимально комфортным как для семьи, так и для молодых специалистов.',
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

  List<Estate> get estates => state;
  List<Estate> get likedEstates => state.where((e) => e.isLiked).toList();

  void toggleLike(int id) {
    final estates = List<Estate>.from(state);
    final index = estates.indexWhere((e) => e.id == id);
    if (index != -1) {
      estates[index] = estates[index].copyWith(isLiked: !estates[index].isLiked);
      emit(estates);
    }
  }

  void addEstate(Estate estate) {
    emit([...state, estate]);
  }

  void deleteEstate(int id) {
    emit(state.where((e) => e.id != id).toList());
  }
}

