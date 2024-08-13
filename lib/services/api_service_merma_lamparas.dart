import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://localhost:5000/api/Mermas/mermasLamparas';

  Future<bool> mandarAMerma(
      int cantidad, String descripcion, int inventariolamparaId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Error: No se encontró el token de autenticación.");
      return false;
    }

    final url = Uri.parse('$baseUrl/Mermas/mermaLampara');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'Cantidad': cantidad,
        'Descripcion': descripcion,
        'InventariolamparaId': inventariolamparaId,
      }),
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
