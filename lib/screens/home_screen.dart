import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../core/constants.dart';
import '../widgets/bottom_menu.dart';
import 'settings_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F7FD), // Gündüz Modu Arkaplan
        elevation: 0,
        title: Text(
          'BUDGETBUDDY',
          style: TextStyle(color: Color(0xFF236570)), // Secondary
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFF236570)), // Secondary
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Üst Bakiye Kartı
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF236570),
                    Color(0xFF7ED647)
                  ], // Secondary ve Primary
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Durum',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '+\$2234.56.78',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // İki kutu arasında boşluk bırakır
              children: [
                // Birinci Kutu
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF236570),
                          Color(0xFF7ED647)
                        ], // Secondary ve Primary
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gelir Ekle',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16), // İki kutu arasındaki boşluk
                // İkinci Kutu
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 180, 47, 47),
                          Color.fromARGB(255, 255, 0, 0)
                        ], // Secondary ve Primary
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gider Ekle',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kart Listesi
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: const [
                WalletCard(
                  brand: 'Gider',
                  balance: '\$250,590.00',
                  expiryDate: '58/28',
                  color: Color.fromARGB(255, 250, 2, 2), // Primary
                ),
                WalletCard(
                  brand: 'Visa',
                  balance: '\$250,590.00',
                  expiryDate: '10/23',
                  color: Color(0xFF236570), // Secondary
                ),
                WalletCard(
                  brand: 'Payoneer',
                  balance: '\$350,590.00',
                  expiryDate: '07/25',
                  color: Color(0xFF7ED647), // Primary
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WalletCard extends StatelessWidget {
  final String brand;
  final String balance;
  final String expiryDate;
  final Color color;

  const WalletCard({
    super.key,
    required this.brand,
    required this.balance,
    required this.expiryDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F7FD), // Gündüz Modu Arkaplan
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                brand,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF236570), // Secondary
                ),
              ),
              SizedBox(height: 8),
              Text(
                balance,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF236570), // Secondary
                ),
              ),
            ],
          ),
          Text(
            expiryDate,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF236570), // Secondary
            ),
          ),
        ],
      ),
    );
  }
}
