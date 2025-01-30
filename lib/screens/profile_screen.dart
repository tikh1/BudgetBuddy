import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authservice.dart';
import '../core/themes.dart';
import '../widgets/bottom_menu.dart';

final AuthService _authService = AuthService();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _logoutAndRedirectToLogin() async {
    _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Provider.of<ThemeProvider>(context).isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.onBackground),
                        onPressed: _logoutAndRedirectToLogin,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/photos/susamuru.jpg'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hoşgeldin',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Text(
                      'Cansu',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Katılma Tarihi: 01 Ocak 2023',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
