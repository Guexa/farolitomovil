import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:farolitomovil/models/models_merma_lampara_usuario.dart';

class MermaLamparasUsuarioPage extends StatefulWidget {
  @override
  _MermaLamparasUsuarioPageState createState() =>
      _MermaLamparasUsuarioPageState();
}

class _MermaLamparasUsuarioPageState extends State<MermaLamparasUsuarioPage> {
  List<DetalleMermaLamparaDTO> mermas = [];
  List<DetalleMermaLamparaDTO> filteredMermas = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMermas();
    searchController.addListener(_filterItems);
  }

  Future<void> fetchMermas() async {
    final response = await http.get(
        Uri.parse('https://localhost:5000/api/Mermas/mermasLamparasUsuario'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        mermas = jsonResponse
            .map((data) => DetalleMermaLamparaDTO.fromJson(data))
            .toList();
        filteredMermas = mermas;
      });
    } else {
      throw Exception('Failed to load mermas lamparas');
    }
  }

  void _filterItems() {
    setState(() {
      filteredMermas = mermas
          .where((merma) =>
              merma.lampara
                  ?.toLowerCase()
                  .contains(searchController.text.toLowerCase()) ??
              false)
          .toList();
    });
  }

  void _showDetails(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(filteredMermas[index].lampara ?? 'Sin Nombre'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title:
                      Text('Descripción: ${filteredMermas[index].descripcion}'),
                ),
                ListTile(
                  title: Text('Cantidad: ${filteredMermas[index].cantidad}'),
                ),
                ListTile(
                  title: Text(
                      'Fecha: ${filteredMermas[index].fecha?.toLocal().toString().split(' ')[0]}'),
                ),
                ListTile(
                  title: Text(
                      'Usuario: ${filteredMermas[index].usuario ?? 'Desconocido'}'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFC99838),
        title: const Text(
          'Mermas Lámparas Usuario',
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
              itemCount: filteredMermas.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                        '${filteredMermas[index].lampara ?? 'Sin Nombre'}'),
                    subtitle: Text(
                        '${filteredMermas[index].descripcion} - ${filteredMermas[index].cantidad} unidades'),
                    trailing: IconButton(
                      onPressed: () {
                        _showDetails(index);
                      },
                      icon: Icon(Icons.info),
                    ),
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
