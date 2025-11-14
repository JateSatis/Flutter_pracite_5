// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shared/app_theme.dart';
import 'shared/models/estate.dart';
import 'features/profile/models/profile.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/estate/screens/estates_list_screen.dart';
import 'features/estate/screens/estate_info_screen.dart';
import 'features/estate/screens/estate_form_screen.dart';
import 'features/estate/screens/estate_filter_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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

  void toggleLike(int id) {
    final estate = _estates.firstWhere((e) => e.id == id);
    setState(() {
      estate.isLiked = !estate.isLiked;
    });
  }

  void addEstate(Estate estate) {
    setState(() {
      _estates.add(estate);
    });
  }

  void deleteEstate(int id) {
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

  List<Estate> get likedEstates => _estates.where((e) => e.isLiked).toList();

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/estate/add',
          builder: (context, state) => EstateFormScreen(
            onAddEstate: addEstate,
          ),
        ),
        GoRoute(
          path: '/estate/filters',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return EstateFilterScreen(
              initialTitle: extra?['title'] as String?,
              initialMinPrice: extra?['minPrice'] as int?,
              initialMaxPrice: extra?['maxPrice'] as int?,
            );
          },
        ),
        GoRoute(
          path: '/estate/:id',
          builder: (context, state) {
            final idStr = state.pathParameters['id']!;
            final id = int.parse(idStr);
            final estate = _estates.firstWhere((e) => e.id == id);
            return EstateInfoScreen(
              estate: estate,
              onLikeEstate: toggleLike,
              onDeleteEstate: deleteEstate,
            );
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            int currentIndex;
            final path = state.uri.path;
            if (path == '/') {
              currentIndex = 0;
            } else if (path.startsWith('/profile')) {
              currentIndex = 1;
            } else {
              currentIndex = 0;
            }

            return Scaffold(
              body: child,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  if (index == 0) {
                    context.go('/');
                  } else {
                    context.go('/profile');
                  }
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Недвижимость'),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
                ],
              ),
            );
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => EstatesListScreen(
                estates: _estates,
                onLikeEstate: toggleLike,
                onDeleteEstate: deleteEstate,
                onAddEstate: addEstate,
              ),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileScreen(
                profile: _profile,
                likedEstates: likedEstates,
                onLikeEstate: toggleLike,
                onDeleteEstate: deleteEstate,
              ),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      title: 'Недвижимость',
    );
  }
}