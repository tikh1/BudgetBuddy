import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  Future<void> _saveExpense() async {
    final prefs = await SharedPreferences.getInstance();
    final expenses = prefs.getStringList('expenses') ?? [];

    expenses.add(
      '${_titleController.text}|${_descriptionController.text}|${_amountController.text}',
    );

    await prefs.setStringList('expenses', expenses);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gider Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Başlık'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Açıklama'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Ücret'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveExpense,
              child: Text('Onayla'),
            ),
          ],
        ),
      ),
    );
  }
}