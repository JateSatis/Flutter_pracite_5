// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/estate_repository.dart';
import 'shared/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/estate/screens/estates_list_screen.dart';
import 'features/estate/screens/estate_info_screen.dart';
import 'features/estate/screens/estate_form_screen.dart';
import 'features/estate/screens/estate_filter_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'di_container.dart';

void main() {
  setupDependencies(); // ← инициализируем DI-контейнер до runApp
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _buildRouter(),
      theme: AppTheme.lightTheme,
      title: 'Недвижимость',
    );
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/estate/add',
          builder: (context, state) => const EstateFormScreen(),
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
            final estateRepo = getIt.get<EstateRepository>();
            final estate = estateRepo.estates.firstWhere((e) => e.id == id);
            return EstateInfoScreen(estate: estate);
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
              builder: (context, state) => const EstatesListScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }
}