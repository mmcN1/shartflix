import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://caseapi.servicelabs.tech/user';

  // Login
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveUserData(data['data']);
      return data;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  // Register
  static Future<Map<String, dynamic>> registerUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveUserData(data['data']);
      return data;
    } else {
      throw Exception("Register failed: ${response.body}");
    }
  }

  // SharedPreferences'e kaydet
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    if (userData.containsKey('token')) {
      await prefs.setString('token', userData['token']);
    }
    if (userData.containsKey('name')) {
      await prefs.setString('name', userData['name']);
    }
    if (userData.containsKey('photoUrl')) {
      await prefs.setString('photoUrl', userData['photoUrl']);
    }
  }

  // Token'ı oku
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
