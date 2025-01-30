import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/themes.dart';
import '../services/authservice.dart';
import '../widgets/bottom_menu.dart';

final AuthService _authService = AuthService();

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
            // Üst Menü (Tema Değiştir & Çıkış Butonları)
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Boşluk için
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

            // Profil Fotoğrafı ve "Hakkımızda" Başlığı
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/photos/dark.jpg'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Hakkımızda",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Açıklama Metni
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Bu uygulama, kullanıcıların finansal hareketlerini kolayca yönetebilmesi için tasarlanmıştır. "
                "Gelir ve giderlerinizi kaydedebilir, bütçenizi takip edebilir ve mali durumunuzu kontrol altında tutabilirsiniz.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),

            const SizedBox(height: 30),

            // Ek Bilgiler
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sürüm: 1.0.0",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Geliştirici Ekip: DARK Software",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "İletişim: dark@destekyazilim.com",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),

            const Spacer(), // İçeriği üstte toplamak için

            // Alt Menü
            BottomMenu(),
          ],
        ),
      ),
    );
  }
}
