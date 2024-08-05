import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_inventario_lampara.dart';

class InventarioLamparas extends StatefulWidget {
  @override
  _InventarioLamparasState createState() => _InventarioLamparasState();
}

class _InventarioLamparasState extends State<InventarioLamparas> {
  List<RecetaConDetallesDTO> lamparas = [];
  List<RecetaConDetallesDTO> filteredLamparas = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLamparas();
    searchController.addListener(_filterItems);
  }

  Future<void> fetchLamparas() async {
    final response = await http.get(
        Uri.parse('https://localhost:5000/api/Inventario/inventario-lamparas'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        lamparas = jsonResponse
            .map((data) => RecetaConDetallesDTO.fromJson(data))
            .toList();
        filteredLamparas = lamparas;
      });
    } else {
      throw Exception('Failed to load lamparas');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      filteredLamparas = lamparas
          .where((lampara) => lampara.nombrelampara
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
          title: Text(filteredLamparas[index].nombrelampara),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: filteredLamparas[index].detalles.map((detalle) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.warning, color: Colors.white),
                            Text(' Mandar a Merma',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController cantidadController =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('Mandar a Merma'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  '¿Cuánto deseas mandar a merma de ${detalle.usuario}?'),
                              TextField(
                                controller: cantidadController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Cantidad a mandar a merma'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Aquí puedes agregar la lógica para enviar la cantidad a merma
                                Navigator.of(context).pop(true);
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.drag_handle),
                    title: Text('Usuario: ${detalle.usuario}'),
                    subtitle: Text(
                        'Cantidad: ${detalle.cantidad}, Fecha: ${detalle.fechaProduccion.toLocal()}'),
                  ),
                );
              }).toList(),
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
          'Inventario de Lámparas',
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
            child: Container(
              child: ReorderableListView(
                children: <Widget>[
                  for (int index = 0;
                      index < filteredLamparas.length;
                      index += 1)
                    Card(
                      key: UniqueKey(),
                      child: ListTile(
                        title: Text('${filteredLamparas[index].nombrelampara}'),
                        leading: CircleAvatar(
                          child: Text('${filteredLamparas[index].id}'),
                        ),
                        trailing: Wrap(
                          spacing: 5,
                          children: [
                            IconButton(
                              onPressed: () {
                                _showDetails(index);
                              },
                              icon: Icon(Icons.info),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = lamparas.removeAt(oldIndex);
                    lamparas.insert(newIndex, item);
                    _filterItems();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
