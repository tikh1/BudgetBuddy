import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: LottieBuilder.asset(
          "assets/motions/Animation.json",
          width: 500,
          height: 500,
          onLoaded: (composition) {
            Future.delayed(
              const Duration(seconds: 3),
              () => context.go('/home'),
            );
          },
        ),
      ),
    );
  }
}
