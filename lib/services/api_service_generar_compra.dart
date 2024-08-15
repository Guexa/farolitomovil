import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_compra_dto.dart';

class ApiService {
  final String baseUrl;
  final String token; // Token de autenticación

  ApiService({required this.baseUrl, required this.token});

  Future<void> agregarCompra(AgregarCompraDTO compra) async {
    final url = Uri.parse('$baseUrl/api/Compra/agregar-compras');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Enviar el token en el encabezado
    };
    final body = jsonEncode(compra.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Compra registrada exitosamente');
        print('Respuesta del servidor: ${response.body}');
      } else {
        final responseBody = jsonDecode(response.body);
        print('Error al registrar compra: ${responseBody['message']}');
      }
    } catch (e) {
      print('Error de red o de servidor: $e');
    }
  }
}
