import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_merma_componente_dto.dart';

class ApiServiceMerma {
  Future<bool> mandarAMerma(MermaComponenteDTO merma) async {
    final response = await http.post(
      Uri.parse('https://localhost:5000/api/Inventario/mandar-a-merma'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(merma.toJson()),
    );

    return response.statusCode == 200;
  }
}
