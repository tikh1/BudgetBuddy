import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddIncome extends StatefulWidget {
  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  Future<void> _saveIncome() async {
    final prefs = await SharedPreferences.getInstance();
    final incomes = prefs.getStringList('incomes') ?? [];

    incomes.add(
      '${_titleController.text}|${_descriptionController.text}|${_amountController.text}',
    );

    await prefs.setStringList('incomes', incomes);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gelir Ekle'),
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
              onPressed: _saveIncome,
              child: Text('Onayla'),
            ),
          ],
        ),
      ),
    );
  }
}