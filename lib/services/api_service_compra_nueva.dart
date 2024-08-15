import 'package:farolitomovil/models/models_compra_nueva.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_compra_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<String> agregarCompra(AgregarCompraDTO compraDTO) async {
    // Recuperar el token de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Verificar si el token es null
    if (token == null) {
      return 'Error: Token no encontrado';
    }

    final url = Uri.parse('$baseUrl/api/Compra/agregar-compras');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode(compraDTO.toJson());

    // Imprimir el token y otros detalles para depuración
    print('Token utilizado: $token');
    print('Solicitud a URL: $url');
    print('Body enviado: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Compra registrada exitosamente';
      } else {
        return 'Error al registrar la compra: ${response.body}';
      }
    } catch (e) {
      return 'Error al conectar con el servidor: $e';
    }
  }

  Future<List<Proveedor>> obtenerProveedores() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Error: Token no encontrado');
    }

    final url = Uri.parse('$baseUrl/api/Proveedor/proveedores');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Proveedores recibidos: $data');
      return data.map((json) => Proveedor.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar proveedores: ${response.statusCode}');
    }
  }

  Future<List<Componente>> obtenerComponentes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Error: Token no encontrado');
    }

    final url = Uri.parse('$baseUrl/api/Componente/componentes');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Componentes recibidos: $data');
      return data.map((json) => Componente.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar componentes: ${response.statusCode}');
    }
  }
}
