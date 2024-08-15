import 'package:flutter/material.dart';
import 'package:farolitomovil/services/api_service_compra_nueva.dart';
import 'package:farolitomovil/models/models_compra_nueva.dart';
import 'package:farolitomovil/models/models_compra_dto.dart';

class NuevaCompraPage extends StatefulWidget {
  final VoidCallback onBack;
  final String userToken;

  NuevaCompraPage({Key? key, required this.onBack, required this.userToken})
      : super(key: key);

  @override
  _NuevaCompraPageState createState() => _NuevaCompraPageState();
}

class _NuevaCompraPageState extends State<NuevaCompraPage> {
  late ApiService _apiService;
  late Future<List<Proveedor>> _proveedores;
  late Future<List<Componente>> _componentes;
  Proveedor? _selectedProveedor;
  Componente? _selectedComponente;
  final _cantidadController = TextEditingController();
  final _costoController = TextEditingController();
  final List<DetalleCompraDTO> _detalles = [];

  bool _proveedorSeleccionado = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(baseUrl: 'https://localhost:5000');
    _proveedores = _apiService.obtenerProveedores();
    _componentes = _apiService.obtenerComponentes();
  }

  void _agregarDetalle() {
    if (_selectedProveedor != null && _selectedComponente != null) {
      final cantidad = int.tryParse(_cantidadController.text) ?? 0;
      final costo = double.tryParse(_costoController.text) ?? 0.0;

      if (cantidad > 0 && costo > 0) {
        print("Agregando detalle...");

        final detalle = DetalleCompraDTO(
          componentesId: _selectedComponente!.id,
          cantidad: cantidad,
          costo: costo,
          proveedorId: _selectedProveedor!.id,
        );

        setState(() {
          _detalles.add(detalle);
          _cantidadController.clear();
          _costoController.clear();
          _selectedComponente = null;
          _proveedorSeleccionado = true;
        });
        print("Detalle agregado: ${detalle.toJson()}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('La cantidad y el costo deben ser mayores que cero.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Debe seleccionar un proveedor y un componente.')),
      );
    }
  }

  void _eliminarDetalle(int index) {
    setState(() {
      _detalles.removeAt(index);
    });
  }

  Future<void> _confirmarCompra() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Compra'),
        content: Text('¿Estás seguro de que deseas registrar esta compra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      _registrarCompra();
    }
  }

  void _registrarCompra() async {
    if (_detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debe agregar al menos un detalle de compra.')),
      );
      return;
    }

    if (_selectedProveedor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleccione un proveedor.')),
      );
      return;
    }

    print("Preparando datos para registrar la compra...");

    final compraDTO = AgregarCompraDTO(
      fecha: DateTime.now().toIso8601String().substring(0, 10),
      proveedorId: _selectedProveedor!.id,
      detalles: _detalles,
    );

    print("Datos de la compra: ${compraDTO.toJson()}");

    try {
      final responseMessage = await _apiService.agregarCompra(compraDTO);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMessage)),
      );

      if (responseMessage.contains('exitosamente')) {
        setState(() {
          _detalles.clear();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la compra: $e')),
      );
    }
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
                onChanged: _proveedorSeleccionado
                    ? null
                    : (value) {
                        setState(() {
                          _selectedProveedor = value;
                          print(
                              "Proveedor seleccionado: ${_selectedProveedor?.nombreEmpresa}");
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
                    print(
                        "Componente seleccionado: ${_selectedComponente?.nombre}");
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarDetalle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF012869),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text(
                  'Agregar Detalle',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
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
                    title: Text('ID Componente: ${detalle.componentesId}'),
                    subtitle: Text(
                        'Cantidad: ${detalle.cantidad}, Costo: \$${detalle.costo}, Proveedor ID: ${detalle.proveedorId}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _eliminarDetalle(index),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmarCompra,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC99838),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(color: Colors.white),
                ),
                child: Text(
                  'Registrar Compra',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No hay datos disponibles');
        } else {
          final items = snapshot.data!;
          return DropdownButtonFormField<T>(
            value: selectedValue,
            onChanged: onChanged,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabel(item)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String id,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }
}
