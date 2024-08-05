import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_merma.dart';

class MermaComponentesPage extends StatefulWidget {
  @override
  _MermaComponentesPageState createState() => _MermaComponentesPageState();
}

class _MermaComponentesPageState extends State<MermaComponentesPage> {
  List<MermaComponente> mermas = [];
  List<MermaComponente> filteredMermas = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMermas();
    searchController.addListener(_filterItems);
  }

  Future<void> fetchMermas() async {
    final response = await http
        .get(Uri.parse('https://localhost:5000/api/Mermas/mermasComponentes'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        mermas =
            jsonResponse.map((data) => MermaComponente.fromJson(data)).toList();
        filteredMermas = mermas;
      });
    } else {
      throw Exception('Failed to load mermas componentes');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      filteredMermas = mermas
          .where((merma) => merma.componente
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _showDetails(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(filteredMermas[index].componente),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title:
                      Text('Descripción: ${filteredMermas[index].descripcion}'),
                  subtitle: Text(
                      'Cantidad: ${filteredMermas[index].cantidad} unidades'),
                ),
                // Añadir más detalles si es necesario
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFC99838),
        title: const Text(
          'Mermas Componentes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                return GestureDetector(
                  onLongPress: () => _showDetails(index),
                  onDoubleTap: () => _showDetails(index),
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(filteredMermas[index].componente),
                      subtitle: Text(
                        '${filteredMermas[index].descripcion} - ${filteredMermas[index].cantidad} unidades',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          _showDetails(index);
                        },
                      ),
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
