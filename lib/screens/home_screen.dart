import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/api.dart';
import '../core/themes.dart';
import 'addexpense_screen.dart';
import 'addincome_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/authservice.dart';
import '../services/dataservice.dart';

final AuthService _authService = AuthService();
final DataService _dataService = DataService();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalBalance = 0.0;
  List<String> incomes = [];
  bool _isLoading = false;
  String _errorMessage = '';
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final userTransactions = await _dataService.fetchUserTransactionHistory();
    if (userTransactions.success) {
      final transactionData = userTransactions.data![0] as Map<String, dynamic>;
      setState(() {
        incomes = transactionData['incomes'] as List<String>;
        totalIncome = transactionData['totalincome'].toDouble();
        totalExpense = transactionData['totalexpense'].toDouble();
        totalBalance = transactionData['totalbalance'].toDouble();
        _isLoading = false;
      });
    }
  }

  Future<void> _logoutAndRedirectToLogin() async {
    _authService.logout();
    context.go('/login');
  }

  Widget _buildListItem(String title, String description, String amount,
      String spendingDate, Color backgroundColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)),
          ),
          const SizedBox(height: 4),
          Text(
            '\₺${amount}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            spendingDate,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar'ı tamamen kaldırıyoruz
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Üstteki satır: Profil fotoğrafı, yazılar ve sağ üstteki butonlar
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 24.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Öğeler arasında eşit boşluk
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Dikeyde ortala
                    children: [
                      // Profil Fotoğrafı ve Hoşgeldin Cansu Yazısı
                      Row(
                        children: [
                          // Profil Fotoğrafı (Daha küçük boyutta)
                          CircleAvatar(
                            radius: 25, // Yarıçapı küçülttük
                            backgroundImage: AssetImage(
                                'assets/profile_image.png'), // Statik profil fotoğrafı
                          ),
                          const SizedBox(width: 16),
                          // Hoşgeldin Cansu Yazısı (İki satır)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hoşgeldin',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                              Text(
                                'Cansu',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Sağ üstteki butonlar (Tema değişim ve çıkış)
                      Row(
                        children: [
                          // Tema değişim butonu
                          IconButton(
                            icon: Icon(
                              Provider.of<ThemeProvider>(context).isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            onPressed: () {
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme();
                            },
                          ),
                          // Çıkış ikonu
                          IconButton(
                            icon: Icon(Icons.logout,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            onPressed: _logoutAndRedirectToLogin,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Durum Kutusu
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Durum',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '\₺${totalBalance.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Gelir/Gider Listesi
                Expanded(
                  child: ListView(
                    children: [
                      ...incomes.map((income) {
                        final parts = income.split('|');
                        return _buildListItem(
                          parts[0],
                          parts[1],
                          parts[2],
                          parts[3],
                          parts[4] == "1"
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddIncome()),
            ).then((_) => _fetchData()),
            tooltip: 'Gelir Ekle',
            child:
                Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpense()),
            ).then((_) => _fetchData()),
            tooltip: 'Gider Ekle',
            child: Icon(Icons.remove,
                color: Theme.of(context).colorScheme.onPrimary),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}
