import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import '../models/userdetaildto.dart';
import '../models/models_update_user_dto.dart';

class ApiServiceUpdateUser {
  final String baseUrl = 'https://localhost:5000/api/Usuario';

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

  Future<bool> updateUserDetails(UpdateUserDTO userDetails) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(userDetails.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> uploadUserImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/image'))
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'webp'),
      ));

    final response = await request.send();
    return response.statusCode == 200;
  }
}
