import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';



import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'addexpense.dart';
import 'addincome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
    _screen();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIncomes = prefs.getStringList('incomes') ?? [];

    double incomeTotal = storedIncomes.fold(0.0, (sum, item) {
      final amount = double.tryParse(item.split('|')[2]) ?? 0.0;
      return sum + amount;
    });

    setState(() {
      incomes = storedIncomes;
    });
  }

  Future<void> _screen() async {

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = 'https://budgetbuddy.glosoft.net/api/expenditures/'; // API URL'nizi buraya ekleyin
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.getString('token');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {

          final incomes = responseData['data'].map<String>((income) {
            return '${income['title']}|${income['description']}|${income['amount']}|${income['type']}';
          }).toList();

            responseData['data'].forEach((item) {
              final amount = double.tryParse(item['amount']) ?? 0.0;
              if (item['type'] == 1) {
                totalIncome += amount;
              } else {
                totalExpense += amount;
              }
            });
            totalBalance = totalIncome - totalExpense;
          setState(() {
            this.incomes = incomes;
            //totalBalance = incomeTotal - expenseTotal;
          });
        } else {
          setState(() {
            _errorMessage = 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = '{$error}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Widget _buildListItem(String title, String description, String amount, Color backgroundColor) {
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          SizedBox(height: 4),
          Text(
            '\$${amount}',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BudgetBuddy'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Color(0xFF236570), Color(0xFF7ED647)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Durum',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${totalBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ...incomes.map((income) {
                  final parts = income.split('|');
                  return _buildListItem(parts[0], parts[1], parts[2], parts[3] == "1" ? Colors.green : Colors.red);
                }).toList(),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mevcut Durumunuz:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '\$${totalBalance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: totalBalance >= 0 ? Colors.green : Colors.red,
                  ),
                ),
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
            ).then((_) => _loadData()),
            tooltip: 'Gelir Ekle',
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpense()),
            ).then((_) => _loadData()),
            tooltip: 'Gider Ekle',
            child: Icon(Icons.remove, color: Colors.white),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}