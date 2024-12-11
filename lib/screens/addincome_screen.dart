import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api.dart';

class AddIncome extends StatefulWidget {
  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _typeController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _addincome() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final amount = _amountController.text;
    final date = _dateController.text;

    if (title.isEmpty || description.isEmpty || amount.isEmpty || date.isEmpty) {
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
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.getString('token');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: json.encode({
          'type': 1,
          'title': title,
          'description': description,
          'amount': amount,
          'spending_date': date
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          Navigator.pop(context);
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
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
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Tarih',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _addincome,
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
