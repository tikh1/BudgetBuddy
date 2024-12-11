import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _addExpense() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final amount = _amountController.text;

    if (title.isEmpty || description.isEmpty || amount.isEmpty) {
      setState(() {
        _errorMessage = 'Lütfen tüm alanları doldurun';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = API_BASE + API_EXPENDITURES; // API URL'nizi buraya ekleyin
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'description': description,
          'amount': amount ,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['data']['token']);
          context.go('/home');
        } else {
          setState(() {
            _errorMessage = 'Kayıt başarısız. Lütfen tekrar deneyin.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Kayıt başarısız. Lütfen bilgilerinizi kontrol edin.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Bir hata oluştu. Lütfen tekrar deneyin.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              onPressed: _isLoading ? null : _addExpense,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Onayla'),
            ),
          ],
        ),
      ),
    );
  }
}