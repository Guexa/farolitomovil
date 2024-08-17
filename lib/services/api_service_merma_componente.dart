import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models_merma_componente_dto.dart';

class ApiServiceMerma {
  final String apiUrl =
      'http://192.168.175.212:5000/api/Mermas/mermaComponente';

  Future<bool> mandarAMerma(MermaComponenteDTO merma) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Error: No se encontró el token de autenticación.");
      return false;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(merma.toJson()),
    );

    if (response.statusCode == 200) {
      print("Éxito al mandar a merma.");
      return true;
    } else {
      print(
          "Error al mandar a merma. Código de estado: ${response.statusCode}");
      print("Respuesta del cuerpo: ${response.body}");
      return false;
    }
  }
}
