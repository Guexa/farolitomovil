import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farolitomovil/models/auth_response_dto.dart';

class ApiService {
  static const String apiUrl = 'http://192.168.175.212:5000/api/Usuario/login';

  Future<AuthResponseDTO?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final authResponse = AuthResponseDTO.fromJson(jsonDecode(response.body));

      // Guardar el token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', authResponse.token);

      return authResponse;
    } else {
      return null;
    }
  }
}
