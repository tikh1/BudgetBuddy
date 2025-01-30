import 'package:budgetbuddy/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/home_screen.dart';
import '../services/authservice.dart';

final AuthService _authService = AuthService();

final router = GoRouter(
  initialLocation: '/loading',
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
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
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
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
