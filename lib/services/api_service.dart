import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/auth_response_dto.dart';

class ApiService {
  static const String apiUrl = 'https://localhost:5000/api/Usuario/login';

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
      return AuthResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
