import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://localhost:5000/api/Mermas';

  Future<bool> mandarAMerma(
      int cantidad, String descripcion, int inventariolamparaId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Verificar si se obtuvo el token
    if (token == null) {
      print("Error: No se encontró el token de autenticación.");
      return false;
    } else {
      print("Token obtenido: $token");
    }

    final url = Uri.parse(
        '$baseUrl/mermaLampara'); // Corrige la URL aquí si es necesario
    print("URL: $url");

    // Crear el cuerpo de la solicitud
    final body = json.encode({
      'cantidad': cantidad,
      'descripcion': descripcion,
      'inventariolamparaId': inventariolamparaId,
    });

    // Realizar la solicitud POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    // Manejar la respuesta de la API
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
