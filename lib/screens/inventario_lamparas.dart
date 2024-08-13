import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_inventario_lampara.dart';
import 'package:farolitomovil/services/api_service_merma_lamparas.dart';

class InventarioLamparas extends StatefulWidget {
  @override
  _InventarioLamparasState createState() => _InventarioLamparasState();
}

class _InventarioLamparasState extends State<InventarioLamparas> {
  List<RecetaConDetallesDTO> lamparas = [];
  List<RecetaConDetallesDTO> filteredLamparas = [];
  TextEditingController searchController = TextEditingController();
  ApiService apiService = ApiService();

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
        TextEditingController cantidadController = TextEditingController();
        TextEditingController descripcionController = TextEditingController();
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
                              TextField(
                                controller: descripcionController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Descripción del problema'),
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
                              onPressed: () async {
                                // Validar la cantidad
                                int cantidad =
                                    int.tryParse(cantidadController.text) ?? 0;
                                if (cantidad <= 0) {
                                  _showErrorDialog(
                                      'La cantidad debe ser mayor a 0.');
                                  return;
                                }
                                if (cantidad > detalle.cantidad) {
                                  _showErrorDialog(
                                      'La cantidad a mandar a merma no puede ser mayor a la disponible (${detalle.cantidad}).');
                                  return;
                                }

                                // Realizar el envío
                                bool success = await apiService.mandarAMerma(
                                  cantidad,
                                  descripcionController.text,
                                  detalle.id,
                                );

                                Navigator.of(context).pop(success);
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
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
