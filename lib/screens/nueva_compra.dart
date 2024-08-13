import 'package:flutter/material.dart';
import 'package:farolitomovil/services/api_service_compra_nueva.dart';
import 'package:farolitomovil/models/models_compra_nueva.dart';

class NuevaCompraPage extends StatefulWidget {
  final VoidCallback onBack;

  NuevaCompraPage({Key? key, required this.onBack}) : super(key: key);

  @override
  _NuevaCompraPageState createState() => _NuevaCompraPageState();
}

class _NuevaCompraPageState extends State<NuevaCompraPage> {
  final ApiService _apiService = ApiService(baseUrl: 'https://localhost:5000');
  late Future<List<Proveedor>> _proveedores;
  late Future<List<Componente>> _componentes;
  Proveedor? _selectedProveedor;
  Componente? _selectedComponente;
  final _cantidadController = TextEditingController();
  final _costoController = TextEditingController();
  final List<DetalleCompra> _detalles = [];

  @override
  void initState() {
    super.initState();
    _proveedores = _apiService.obtenerProveedores();
    _componentes = _apiService.obtenerComponentes();
  }

  void _agregarDetalle() {
    if (_selectedProveedor != null && _selectedComponente != null) {
      final cantidad = int.tryParse(_cantidadController.text) ?? 0;
      final costo = double.tryParse(_costoController.text) ?? 0.0;
      final detalle = DetalleCompra(
        proveedor: _selectedProveedor!.nombreEmpresa,
        componente: _selectedComponente!.nombre,
        cantidad: cantidad,
        costo: costo,
      );
      setState(() {
        _detalles.add(detalle);
        _cantidadController.clear();
        _costoController.clear();
        _selectedProveedor = null;
        _selectedComponente = null;
      });
    }
  }

  void _eliminarDetalle(int index) {
    setState(() {
      _detalles.removeAt(index);
    });
  }

  void _registrarCompra() {
    // Lógica para registrar la compra
  }

  Widget _buildDropdown<T>({
    required Future<List<T>> future,
    required String labelText,
    required T? selectedValue,
    required void Function(T?)? onChanged,
    required String Function(T) itemLabel,
  }) {
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error al cargar $labelText');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No hay datos disponibles');
        } else {
          return DropdownButtonFormField<T>(
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: snapshot.data!
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(itemLabel(item)),
                    ))
                .toList(),
            onChanged: onChanged,
            value: selectedValue,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFC99838),
        title: Text(
          'Nueva Compra',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown<Proveedor>(
                future: _proveedores,
                labelText: 'Proveedor',
                selectedValue: _selectedProveedor,
                onChanged: (value) {
                  setState(() {
                    _selectedProveedor = value;
                  });
                },
                itemLabel: (item) => item.nombreEmpresa,
              ),
              SizedBox(height: 10),
              _buildDropdown<Componente>(
                future: _componentes,
                labelText: 'Componente',
                selectedValue: _selectedComponente,
                onChanged: (value) {
                  setState(() {
                    _selectedComponente = value;
                  });
                },
                itemLabel: (item) => item.nombre,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _cantidadController,
                labelText: 'Cantidad',
                icon: Icons.format_list_numbered,
                id: 'cantidadTextField',
              ),
              _buildTextField(
                controller: _costoController,
                labelText: 'Costo',
                icon: Icons.attach_money,
                id: 'costoTextField',
              ),
              ElevatedButton(
                onPressed: _agregarDetalle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF012869),
                  padding: EdgeInsets.symmetric(horizontal: 50),
                ),
                child: Text('Agregar Detalle'),
              ),
              SizedBox(height: 10),
              Text(
                'Detalles de la compra:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _detalles.length,
                itemBuilder: (context, index) {
                  final detalle = _detalles[index];
                  return ListTile(
                    title: Text(detalle.componente),
                    subtitle: Text(
                        'Cantidad: ${detalle.cantidad}, Costo: \$${detalle.costo}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _eliminarDetalle(index),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _registrarCompra,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC99838),
                  padding: EdgeInsets.symmetric(horizontal: 50),
                ),
                child: Text('Registrar Compra'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String id,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: id == 'cantidadTextField'
          ? TextInputType.number
          : TextInputType.numberWithOptions(decimal: true),
    );
  }

  @override
  void dispose() {
    widget.onBack(); // Llamada a la función onBack cuando se cierra la página
    super.dispose();
  }
}

class DetalleCompra {
  final String proveedor;
  final String componente;
  final int cantidad;
  final double costo;

  DetalleCompra({
    required this.proveedor,
    required this.componente,
    required this.cantidad,
    required this.costo,
  });
}


// import 'package:flutter/material.dart';
// import 'package:farolitomovil/services/api_service_compra_nueva.dart';
// import 'package:farolitomovil/models/models_compra_nueva.dart';

// class NuevaCompraPage extends StatefulWidget {
//   final VoidCallback onBack;

//   NuevaCompraPage({Key? key, required this.onBack}) : super(key: key);

//   @override
//   _NuevaCompraPageState createState() => _NuevaCompraPageState();
// }

// class _NuevaCompraPageState extends State<NuevaCompraPage> {
//   final TextEditingController _cantidadController = TextEditingController();
//   final TextEditingController _costoController = TextEditingController();
//   final List<DetalleCompra> _detalles = [];

//   late Future<List<Proveedor>> _proveedores;
//   late Future<List<Componente>> _componentes;
//   Proveedor? _selectedProveedor;
//   Componente? _selectedComponente;

//   final ApiService _apiService = ApiService(baseUrl: 'https://localhost:5000');

//   @override
//   void initState() {
//     super.initState();
//     _proveedores = _apiService.obtenerProveedores();
//     _componentes = _apiService.obtenerComponentes();
//   }

//   void _agregarDetalle() {
//     if (_selectedComponente != null) {
//       setState(() {
//         _detalles.add(
//           DetalleCompra(
//             componente: _selectedComponente!.nombre,
//             cantidad: int.tryParse(_cantidadController.text) ?? 0,
//             costo: double.tryParse(_costoController.text) ?? 0.0,
//           ),
//         );
//         _cantidadController.clear();
//         _costoController.clear();
//       });
//     }
//   }

//   void _eliminarDetalle(int index) {
//     setState(() {
//       _detalles.removeAt(index);
//     });
//   }

//   Future<void> _registrarCompra() async {
//     if (_selectedProveedor == null || _detalles.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content:
//                 Text('Seleccione un proveedor y agregue al menos un detalle')),
//       );
//       return;
//     }

//     try {
//       final componentes = await _componentes;

//       final detallesDTO = _detalles.map((detalle) {
//         final componente = componentes.firstWhere(
//           (c) => c.nombre == detalle.componente,
//           orElse: () =>
//               Componente(id: '-1', nombre: 'Desconocido'), // Componente dummy
//         );
//         return DetalleCompraDTO(
//           componentesId: componente.id,
//           cantidad: detalle.cantidad,
//           costo: detalle.costo,
//         );
//       }).toList();

//       final compraDTO = AgregarCompraDTO(
//         proveedorId: _selectedProveedor!.id,
//         detalles: detallesDTO,
//       );

//       await _apiService.agregarCompra(compraDTO);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Compra registrada exitosamente')),
//       );
//       setState(() {
//         _detalles.clear();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al registrar la compra: $e')),
//       );
//     }
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     required IconData icon,
//     required String id,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: labelText,
//           prefixIcon: Icon(icon),
//           helperText: 'Ingrese su $labelText',
//           errorText: controller.text.isEmpty
//               ? 'Ingrese información a este campo'
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//         ),
//         key: Key(id),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: const Color(0xFFC99838),
//         title: const Text(
//           'Nueva compra',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FutureBuilder<List<Proveedor>>(
//                 future: _proveedores,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Text('Error al cargar proveedores');
//                   } else {
//                     return DropdownButtonFormField<Proveedor>(
//                       decoration: InputDecoration(
//                         labelText: 'Proveedor',
//                         prefixIcon: Icon(Icons.business),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       items: snapshot.data!
//                           .map((proveedor) => DropdownMenuItem(
//                                 value: proveedor,
//                                 child: Text(proveedor.nombre),
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedProveedor = value;
//                         });
//                       },
//                       value: _selectedProveedor,
//                     );
//                   }
//                 },
//               ),
//               SizedBox(height: 10),
//               FutureBuilder<List<Componente>>(
//                 future: _componentes,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Text('Error al cargar componentes');
//                   } else {
//                     return DropdownButtonFormField<Componente>(
//                       decoration: InputDecoration(
//                         labelText: 'Componente',
//                         prefixIcon: Icon(Icons.build),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       items: snapshot.data!
//                           .map((componente) => DropdownMenuItem(
//                                 value: componente,
//                                 child: Text(componente.nombre),
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedComponente = value;
//                         });
//                       },
//                       value: _selectedComponente,
//                     );
//                   }
//                 },
//               ),
//               SizedBox(height: 10),
//               _buildTextField(
//                 controller: _cantidadController,
//                 labelText: 'Cantidad',
//                 icon: Icons.format_list_numbered,
//                 id: 'cantidadTextField',
//               ),
//               _buildTextField(
//                 controller: _costoController,
//                 labelText: 'Costo',
//                 icon: Icons.attach_money,
//                 id: 'costoTextField',
//               ),
//               ElevatedButton(
//                 onPressed: _agregarDetalle,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF012869),
//                   padding: const EdgeInsets.symmetric(horizontal: 50),
//                 ),
//                 child: Text('Agregar Detalle'),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Detalles de la compra:',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: _detalles.length,
//                 itemBuilder: (context, index) {
//                   final detalle = _detalles[index];
//                   return ListTile(
//                     title: Text(detalle.componente),
//                     subtitle: Text(
//                         'Cantidad: ${detalle.cantidad}, Costo: \$${detalle.costo}'),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () => _eliminarDetalle(index),
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _registrarCompra,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFC99838),
//                   padding: const EdgeInsets.symmetric(horizontal: 50),
//                 ),
//                 child: Text('Registrar Compra'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
