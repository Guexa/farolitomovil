import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/userdetaildto.dart';

class ApiService {
  final String baseUrl = 'http://192.168.175.212:5000/api/Usuario';

  Future<UserDetailDTO?> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/detail'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserDetailDTO.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
