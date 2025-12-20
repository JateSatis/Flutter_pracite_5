// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_5_project/shared/cubits/estate_cubit.dart';
import 'shared/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/estate/screens/estates_list_screen.dart';
import 'features/estate/screens/estate_info_screen.dart';
import 'features/estate/screens/estate_form_screen.dart';
import 'features/estate/screens/estate_filter_screen.dart';
import 'features/estate/screens/reviews_screen.dart';
import 'features/estate/screens/my_estates_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/chat/screens/chat_list_screen.dart';
import 'features/chat/screens/chat_screen.dart';

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
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
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
              initialMinRating: extra?['minRating'] as double?,
            );
          },
        ),
        GoRoute(
          path: '/estate/:id',
          builder: (context, state) {
            final idStr = state.pathParameters['id']!;
            final id = int.parse(idStr);
            final estates = context.read<EstateCubit>().estates;
            final estate = estates.firstWhere((e) => e.id == id);
            return EstateInfoScreen(estate: estate);
          },
        ),
        GoRoute(
          path: '/estate/:id/reviews',
          builder: (context, state) {
            final idStr = state.pathParameters['id']!;
            final id = int.parse(idStr);
            return ReviewsScreen(estateId: id);
          },
        ),
        GoRoute(
          path: '/chat/:id',
          builder: (context, state) {
            final idStr = state.pathParameters['id']!;
            final id = int.parse(idStr);
            return ChatScreen(chatId: id);
          },
        ),
        GoRoute(
          path: '/my-estates',
          builder: (context, state) => const MyEstatesScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            int currentIndex;
            final path = state.uri.path;
            if (path == '/') {
              currentIndex = 0;
            } else if (path.startsWith('/chats')) {
              currentIndex = 1;
            } else if (path.startsWith('/profile')) {
              currentIndex = 2;
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
                  } else if (index == 1) {
                    context.go('/chats');
                  } else {
                    context.go('/profile');
                  }
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Недвижимость'),
                  BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Чаты'),
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
              path: '/chats',
              builder: (context, state) => const ChatListScreen(),
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