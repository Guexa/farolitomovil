import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:farolitomovil/models/models_merma_componente_dto.dart';
import 'package:farolitomovil/models/models.dart';
import 'package:farolitomovil/services/api_service_merma_componente.dart';

class InventarioComponentes extends StatefulWidget {
  @override
  _InventarioComponentesState createState() => _InventarioComponentesState();
}

class _InventarioComponentesState extends State<InventarioComponentes> {
  List<ComponenteConDetallesDTO> componentes = [];
  List<ComponenteConDetallesDTO> filteredComponentes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchComponentes();
    searchController.addListener(_filterItems);
  }

  Future<void> fetchComponentes() async {
    final response = await http.get(Uri.parse(
        'http://192.168.175.212:5000/api/Inventario/inventario-componentes'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        componentes = jsonResponse
            .map((data) => ComponenteConDetallesDTO.fromJson(data))
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
          .where((componente) => componente.nombre
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
          title: Text(filteredComponentes[index].nombre),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: filteredComponentes[index].detalles.map((detalle) {
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
                    bool formFilled = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Mandar a Merma'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  '¿Cuánto deseas mandar a merma de ${detalle.proveedorNombre}?'),
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
                              onPressed: () {
                                int cantidad =
                                    int.tryParse(cantidadController.text) ?? 0;
                                if (cantidad <= 0) {
                                  _showErrorDialog(
                                      'La cantidad debe ser mayor a 0.');
                                  return;
                                }
                                if (cantidad > detalle.cantidad!) {
                                  _showErrorDialog(
                                      'La cantidad a mandar a merma no puede ser mayor a la disponible (${detalle.cantidad}).');
                                  return;
                                }

                                Navigator.of(context).pop(true);
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );

                    if (formFilled) {
                      return await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmar acción'),
                            content: Text(
                                '¿Seguro que quieres mandar a merma ${cantidadController.text} unidades de ${detalle.proveedorNombre}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  bool success = await mandarAMerma(
                                    cantidadController.text,
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
                    }
                    return false;
                  },
                  child: ListTile(
                    leading: Icon(Icons.drag_handle),
                    title: Text('Proveedor: ${detalle.proveedorNombre}'),
                    subtitle: Text(
                        'Cantidad: ${detalle.cantidad}, Fecha: ${detalle.fechaCompra.toLocal()}'),
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

  Future<bool> mandarAMerma(
      String cantidad, String descripcion, int inventarioComponenteId) async {
    MermaComponenteDTO merma = MermaComponenteDTO(
      cantidad: int.parse(cantidad),
      descripcion: descripcion,
      inventarioComponenteId: inventarioComponenteId,
    );

    ApiServiceMerma apiServiceMerma = ApiServiceMerma();
    return await apiServiceMerma.mandarAMerma(merma);
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
          'Inventario de Componentes',
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
                      index < filteredComponentes.length;
                      index += 1)
                    Card(
                      key: UniqueKey(),
                      child: ListTile(
                        title: Text('${filteredComponentes[index].nombre}'),
                        leading: CircleAvatar(
                          backgroundColor: Colors.black, // Fondo negro
                          child: Text(
                            '${filteredComponentes[index].id}',
                            style:
                                TextStyle(color: Colors.white), // Texto blanco
                          ),
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
                              color: const Color(
                                  0xFFC99838), // Icono color 0xFFC99838
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
                    final item = componentes.removeAt(oldIndex);
                    componentes.insert(newIndex, item);
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
