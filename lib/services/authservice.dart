import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/api_response.dart';
import './api.dart';

class AuthService {
  Future<ApiResponse> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return ApiResponse(success: false, error: 'E-posta ve şifre boş olamaz');
    }

    const url = API_BASE + API_LOGIN; // API URL

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
          saveToken(responseData['data']['token']);
          return ApiResponse(success: true);
        } else {
          return ApiResponse(
              success: false,
              error: 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.');
        }
      } else {
        return ApiResponse(
            success: false,
            error: 'Giriş başarısız. Lütfen bilgilerinizi kontrol edin.');
      }
    } catch (error) {
      return ApiResponse(success: false, error: 'Bir hata oluştu: $error');
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
