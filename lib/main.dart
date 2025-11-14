import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'shared/models/estate.dart';
import 'features/profile/models/profile.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/estate/screens/estates_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Недвижимость',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}

class PageContainer extends StatefulWidget {
  final int initialIndex;

  const PageContainer({super.key, this.initialIndex = 0});

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  late int _currentIndex;

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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _toggleLike(int id) {
    final estate = _estates.firstWhere((e) => e.id == id);
    setState(() {
      estate.isLiked = !estate.isLiked;
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

  void _navigateToRealEstate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PageContainer(initialIndex: 0)),
    );
  }

  void _navigateToProfile() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PageContainer(initialIndex: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      EstatesListScreen(
        estates: _estates,
        onLikeEstate: _toggleLike,
        onDeleteEstate: _deleteEstate,
        onAddEstate: _addEstate,
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
        onTap: (index) {
          if (index == 0) {
            _navigateToRealEstate();
          } else {
            _navigateToProfile();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Недвижимость'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}