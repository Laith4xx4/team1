import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String _baseUrl =
      'http://192.168.100.66:5086/api/Auth'; // Assuming Auth controller

  // =================== Login ===================
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return {'token': data['token'], 'role': data['role'] ?? 'User'};
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to login');
    }
  }

  // =================== Register ===================
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password, 'role': role}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'message': data['message'] ?? 'User registered successfully',
        'role': data['role'] ?? 'User',
      };
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to register');
    }
  }
}
