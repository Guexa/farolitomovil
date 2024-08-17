import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_merma_componente_usuario.dart';

class MermaComponentesUsuarioPage extends StatefulWidget {
  @override
  _MermaComponentesUsuarioPageState createState() =>
      _MermaComponentesUsuarioPageState();
}

class _MermaComponentesUsuarioPageState
    extends State<MermaComponentesUsuarioPage> {
  List<DetalleMermaComponenteDTO> componentes = [];
  List<DetalleMermaComponenteDTO> filteredComponentes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchComponentes();
    searchController.addListener(_filterItems);
  }

  Future<void> fetchComponentes() async {
    final response = await http.get(Uri.parse(
        'http://192.168.175.212:5000/api/Mermas/mermasComponentesUsuario'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        componentes = jsonResponse
            .map((data) => DetalleMermaComponenteDTO.fromJson(data))
            .toList();
        filteredComponentes = componentes;
      });
    } else {
      throw Exception('Failed to load componentes');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      filteredComponentes = componentes
          .where((componente) => componente.descripcion
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFC99838),
        title: const Text(
          'Mermas Componentes Usuario',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredComponentes.length,
              itemBuilder: (context, index) {
                final componente = filteredComponentes[index];
                return Card(
                  child: ListTile(
                    title: Text('${componente.descripcion}'),
                    subtitle: Text('Cantidad: ${componente.cantidad}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
