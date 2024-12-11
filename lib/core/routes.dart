import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/history_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/voice_screen.dart';
import '../services/authservice.dart';

final AuthService _authService = AuthService();

// Router yapılandırması
final router = GoRouter(
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) async {
    final bool isAuthenticated = await _authService.isAuthenticated();

    final isLoggingIn = state.matchedLocation == '/login';
    final isRegistering = state.matchedLocation == '/register';

    if (!isAuthenticated && !isLoggingIn && !isRegistering) {
      return '/login';
    }

    if (isAuthenticated && (isLoggingIn || isRegistering)) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
  ],
);
