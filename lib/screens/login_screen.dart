import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/authservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AuthService _authService = AuthService();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String _username = '';
  @override
  void initState() {
    super.initState();
  }

Future<void> _login() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });

  final loginResponse = await _authService.login(email, password);

  if (loginResponse.success) {
    setState(() {
      _isLoading = false;
      _username = loginResponse.username ?? "Kullanıcı"; // Get the username from the API response
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _username);  // Store the username
    context.go('/home');
  } else {
    setState(() {
      _isLoading = false;
      _errorMessage = loginResponse.error!;
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor:
                    Colors.blue, // 'primary' yerine 'backgroundColor'
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
