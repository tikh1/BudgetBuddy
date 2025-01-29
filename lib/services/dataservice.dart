import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/api_response.dart';
import './api.dart';
import './authservice.dart';

final AuthService _authService = AuthService();

class DataService {
  Future<ApiResponse> fetchUserTransactionHistory() async {
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    double totalBalance = 0.0;
    List<String> incomes = [];

    final token = await _authService.getToken();
    const url = API_BASE + API_EXPENDITURES;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        incomes = responseData['data'].map<String>((income) {
          return '${income['title']}|${income['description']}|${income['amount']}|${income['spending_date']}|${income['type']}';
        }).toList();

        totalIncome = 0;
        totalExpense = 0;

        responseData['data'].forEach((item) {
          final amount = double.tryParse(item['amount'].toString()) ?? 0.0;
          item['type'] == 1 ? totalIncome += amount : totalExpense += amount;
        });

        totalBalance = totalIncome - totalExpense;
      }
    }
    Map<String, dynamic> transactionData = {
      'incomes': incomes,
      'totalincome': totalIncome,
      'totalexpense': totalExpense,
      'totalbalance': totalBalance
    };
    return ApiResponse(success: true, data: [transactionData]);
  }
}
