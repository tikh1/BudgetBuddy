import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: "tikhi@key1.com");
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  @override
  void initState() {
    super.initState();
    
    //_checkIsLogged();
  }
  
  Future<void> _checkIsLogged() async {
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.getString('token');

      if (token != null) {
        context.go('/home');
      }
  }
  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Lütfen tüm alanları doldurun';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = 'https://budgetbuddy.glosoft.net/api/login'; // API URL'nizi buraya ekleyin
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['data']['token']);
          _errorMessage = responseData['data']['token'];
          context.go('/home');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Giriş Yap'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.blue, // 'primary' yerine 'backgroundColor'
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                          context.go('/register');
              },
              child: Text(
                'Üye olmak için tıklayınız',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
