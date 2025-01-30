import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/themes.dart';
import 'addexpense_screen.dart';
import 'addincome_screen.dart';
import '../services/authservice.dart';
import '../services/dataservice.dart';
import '../widgets/bottom_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AuthService _authService = AuthService();
final DataService _dataService = DataService();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "Kullanıcı";
  double totalBalance = 0.0;
  List<String> incomes = [];
  bool _isLoading = false;
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
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
    //await _loadUsername();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('xusernamex');

    setState(() {
      username = savedUsername ?? "Kullanıcı";
    });
  }

  Future<void> _logoutAndRedirectToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('xusernamex');
    _authService.logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 34.0, left: 24.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage('assets/photos/susamuru.jpg'),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hoşgeldin',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          )),
                                  Text('${username}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.bold,
                                          )),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Provider.of<ThemeProvider>(context).isDarkMode
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                onPressed: () {
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .toggleTheme();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.logout,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                onPressed: _logoutAndRedirectToLogin,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Durum',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )),
                      Text('₺${totalBalance.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                              )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0), // Sağ ve sol padding azaltıldı
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                        width: 1.5,
                      ),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddIncome()),
                            ).then((_) => _fetchData()),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground), // Siyah renk
                                SizedBox(width: 4),
                                Text(
                                  "Gelir Ekle",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground), // Siyah renk
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 1.5,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          height: 33,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddExpense()),
                            ).then((_) => _fetchData()),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.remove_circle_outline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground), // Siyah renk
                                SizedBox(width: 4),
                                Text(
                                  "Gider Ekle",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground), // Siyah renk
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Geçmiş İşlemler",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView(
                            children: incomes.map((income) {
                              final parts = income.split('|');
                              return ListTile(
                                title: Text(parts[0],
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                subtitle: Text(parts[1],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                trailing: Text(
                                  '₺${parts[2]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
