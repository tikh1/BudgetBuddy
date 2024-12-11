// uygulamada sayfalari ve navigasyon islemlerini burada tanimlicaz

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/loginscreen.dart';
import '../screens/register.dart';
import '../screens/history_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/voice_screen.dart';
import 'authservice.dart'; 

// Router yapılandırması
final router = GoRouter(
  initialLocation: '/login', // Başlangıç rotası
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
    )
  ],
);
