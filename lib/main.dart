// lib/main.dart
import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'shared/models/estate.dart';
import 'features/profile/models/profile.dart';
import 'features/estate/state/estates_container.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Недвижимость',
      theme: AppTheme.lightTheme,
      home: const LoginWrapper(),
    );
  }
}

class LoginWrapper extends StatefulWidget {
  const LoginWrapper({super.key});

  @override
  State<LoginWrapper> createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  bool _isLoggedIn = false;

  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen(onLogin: _handleLogin);
    }

    return HomeScreen();
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Estate> _estates = [
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

  final Profile _profile = Profile(
    name: 'Максим Данилов',
    imageUrl: 'https://avatars.githubusercontent.com/u/77029208?v=4',
  );

  void _toggleLike(int id) {
    final estate = _estates.firstWhere((e) => e.id == id);
    final wasLiked = estate.isLiked;

    setState(() {
      estate.isLiked = !wasLiked;
    });
  }

  void _addEstate(Estate estate) {
    setState(() {
      _estates.add(estate);
    });
  }

  void _deleteEstate(int id) {
    final estateToDelete = _estates.firstWhere((e) => e.id == id);
    final index = _estates.indexOf(estateToDelete);
    final wasLiked = estateToDelete.isLiked;

    setState(() {
      _estates.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Объект удалён'),
        action: SnackBarAction(
          label: 'Отмена',
          onPressed: () {
            setState(() {
              _estates.insert(index, estateToDelete);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      EstatesContainer(
        estates: _estates,
        onAddEstate: _addEstate,
        onLikeEstate: _toggleLike,
        onDeleteEstate: _deleteEstate,
      ),
      ProfileScreen(
        profile: _profile,
        likedEstates: _estates.where((e) => e.isLiked).toList(),
        onLikeEstate: _toggleLike,
        onDeleteEstate: _deleteEstate,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Недвижимость'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}