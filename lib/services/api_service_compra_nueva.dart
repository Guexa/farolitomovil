import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_compra_nueva.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Proveedor>> obtenerProveedores() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/Proveedor/proveedores'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Proveedor.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar proveedores');
    }
  }

  Future<List<Componente>> obtenerComponentes() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/Componente/componentes'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Componente.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar componentes');
    }
  }

  Future<void> agregarCompra(AgregarCompraDTO compraDTO) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Compra/agregar-compras'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(compraDTO.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al registrar la compra');
    }
  }
}
