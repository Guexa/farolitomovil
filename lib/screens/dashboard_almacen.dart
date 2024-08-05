import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardAlmacen(),
    );
  }
}

class DashboardAlmacen extends StatefulWidget {
  @override
  _DashboardAlmacenState createState() => _DashboardAlmacenState();
}

class _DashboardAlmacenState extends State<DashboardAlmacen> {
  String? _selectedOption;
  final List<String> _options = ['Gráfica 1', 'Gráfica 2', 'Gráfica 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color(0xFFbf8b24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('¿Qué quieres ver?'),
            DropdownButton<String>(
              hint: Text('Selecciona una opción'),
              value: _selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
              items: _options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
              child: Center(
                child: _selectedOption == null
                    ? Text('Aún no seleccionas ninguna opción')
                    : _buildDashboard(_selectedOption!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(String option) {
    return Text('Mostrando: $option');
  }
}
