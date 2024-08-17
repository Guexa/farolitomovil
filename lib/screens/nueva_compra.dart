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
  final List<String> _nombresComponentes =
      []; // Lista para almacenar los nombres de los componentes

  bool _proveedorSeleccionado = false;
  double _costoTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(baseUrl: 'http://192.168.175.212:5000');
    _proveedores = _apiService.obtenerProveedores();
    _componentes = _apiService.obtenerComponentes();
  }

  void _agregarDetalle() {
    if (_selectedProveedor != null && _selectedComponente != null) {
      final cantidad = int.tryParse(_cantidadController.text) ?? 0;
      final costo = double.tryParse(_costoController.text) ?? 0.0;

      if (cantidad > 0 && costo > 0) {
        // Validación para actualizar cantidad si el componente ya está en el carrito
        final existingDetailIndex = _detalles.indexWhere((detalle) =>
            detalle.componentesId == _selectedComponente!.id &&
            detalle.proveedorId == _selectedProveedor!.id);

        if (existingDetailIndex != -1) {
          setState(() {
            _detalles[existingDetailIndex].cantidad += cantidad;
            _detalles[existingDetailIndex].costo +=
                costo * cantidad; // Ajuste en la suma
            _costoTotal += costo * cantidad; // Ajuste en la suma del total
          });
        } else {
          final detalle = DetalleCompraDTO(
            componentesId: _selectedComponente!.id,
            cantidad: cantidad,
            costo: costo * cantidad, // Ajuste en el cálculo
            proveedorId: _selectedProveedor!.id,
          );

          setState(() {
            _detalles.add(detalle);
            _nombresComponentes.add(_selectedComponente!
                .nombre); // Almacenar el nombre del componente
            _costoTotal += costo * cantidad; // Ajuste en la suma del total
          });
        }

        _cantidadController.clear();
        _costoController.clear();
        _selectedComponente = null;
        _proveedorSeleccionado = true;
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
      _costoTotal -= _detalles[index].costo;
      _detalles.removeAt(index);
      _nombresComponentes
          .removeAt(index); // También eliminar el nombre del componente
      if (_detalles.isEmpty) {
        _proveedorSeleccionado = false;
      }
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

    final compraDTO = AgregarCompraDTO(
      fecha: DateTime.now().toIso8601String().substring(0, 10),
      proveedorId: _selectedProveedor!.id,
      detalles: _detalles,
    );

    try {
      final responseMessage = await _apiService.agregarCompra(compraDTO);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMessage)),
      );

      if (responseMessage.contains('exitosamente')) {
        setState(() {
          _detalles.clear();
          _nombresComponentes.clear(); // Limpiar la lista de nombres
          _costoTotal = 0.0;
          _proveedorSeleccionado = false;
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
              Container(
                color: Colors.grey[200], // Fondo gris claro para el contenedor
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _detalles.length,
                  itemBuilder: (context, index) {
                    final detalle = _detalles[index];
                    return ListTile(
                      title: Text(
                          'Componente: ${_nombresComponentes[index]}, Nombre: ${_nombresComponentes[index]}'),
                      subtitle: Text(
                          'Cantidad: ${detalle.cantidad}, Costo: \$${detalle.costo}, Proveedor: ${_selectedProveedor?.nombreEmpresa ?? "Desconocido"}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarDetalle(index),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Costo Total: \$$_costoTotal',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
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
    required ValueChanged<T?>? onChanged,
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
          return DropdownButtonFormField<T>(
            value: selectedValue,
            onChanged: onChanged,
            items: snapshot.data!.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(itemLabel(value)),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(),
            ),
            isExpanded: true,
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
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      keyboardType:
          id == 'costoTextField' ? TextInputType.number : TextInputType.number,
      key: Key(id),
    );
  }
}
