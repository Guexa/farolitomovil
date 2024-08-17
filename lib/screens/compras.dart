import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:farolitomovil/models/models_compra.dart';
import 'nueva_compra.dart';

class Compras extends StatefulWidget {
  final Function(Widget) onSelectPage;

  Compras({required this.onSelectPage});

  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  List<Compraview> compras = [];
  List<Compraview> filteredCompras = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCompras();
    searchController.addListener(_filterItems);
  }

  Future<void> fetchCompras() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/api/Compra/compras'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        compras =
            jsonResponse.map((data) => Compraview.fromJson(data)).toList();
        filteredCompras = compras;
      });
    } else {
      throw Exception('Failed to load compras');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      filteredCompras = compras
          .where((compra) => compra.usuarioNombre
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
          title: Text('Compra #${index + 1}'), // Mostrar número generado
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: filteredCompras[index].detalles.map((detalle) {
                return ListTile(
                  title: Text(detalle.nombreComponente),
                  subtitle: Text(
                      'Cantidad: ${detalle.cantidad}, Costo: ${detalle.costo}'),
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

  void _handleBackToCompras() {
    widget.onSelectPage(Compras(onSelectPage: widget.onSelectPage));
  }

  void _addCompra() {
    final userToken =
        'your_user_token_here'; // Reemplaza esto con la forma correcta de obtener el token
    widget.onSelectPage(NuevaCompraPage(
      onBack: _handleBackToCompras,
      userToken: userToken, // Asegúrate de pasar el token aquí
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFC99838),
        title: const Text(
          'Compras',
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
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCompras.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () => _showDetails(index),
                  onDoubleTap: () => _showDetails(index),
                  child: Card(
                    color: Colors.grey[200],
                    child: ListTile(
                      title: Text(
                        'Compra #${index + 1}', // Mostrar número generado
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Text(
                          '${index + 1}', // Mostrar número generado
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        'Usuario: ${filteredCompras[index].usuarioNombre}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Icon(
                        Icons.info,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCompra,
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFFC99838),
      ),
    );
  }
}
