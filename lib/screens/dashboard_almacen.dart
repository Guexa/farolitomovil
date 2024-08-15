import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DashboardAlmacen extends StatefulWidget {
  @override
  _DashboardAlmacenState createState() => _DashboardAlmacenState();
}

class _DashboardAlmacenState extends State<DashboardAlmacen> {
  String? _selectedOption;
  final List<String> _options = [
    'Gráfica de Componentes',
    'Gráfica de Lámparas',
  ];

  List<dynamic> _componentes = [];
  List<dynamic> _lamparas = [];

  @override
  void initState() {
    super.initState();
    _fetchComponentes();
    _fetchLamparas();
  }

  Future<void> _fetchComponentes() async {
    final response = await http.get(Uri.parse(
        'https://localhost:5000/api/Dashboard/ExistenciasComponentes'));

    if (response.statusCode == 200) {
      setState(() {
        _componentes = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load componentes');
    }
  }

  Future<void> _fetchLamparas() async {
    final response = await http.get(
        Uri.parse('https://localhost:5000/api/Dashboard/ExistenciasLampara'));

    if (response.statusCode == 200) {
      setState(() {
        _lamparas = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load lámparas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Dashboard Almacen',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color(0xFFbf8b24),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '¿Qué quieres ver?',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 300,
                child: DropdownButton<String>(
                  isExpanded: true,
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
              ),
              SizedBox(height: 20),
              _selectedOption == null
                  ? Center(child: Text('Aún no seleccionas ninguna opción'))
                  : _buildDashboard(_selectedOption!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(String option) {
    switch (option) {
      case 'Gráfica de Componentes':
        return Column(
          children: [
            _buildComponenteChart(),
            _buildComponenteTable(),
          ],
        );
      case 'Gráfica de Lámparas':
        return Column(
          children: [
            _buildLamparaChart(),
            _buildLamparaTable(),
          ],
        );
      default:
        return Text('Opción no válida');
    }
  }

  Widget _buildComponenteChart() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Existencias de Componentes'),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          BarSeries<dynamic, String>(
            dataSource: _componentes,
            xValueMapper: (dynamic data, _) => data['componente'],
            yValueMapper: (dynamic data, _) => data['existencia'],
            name: 'Existencias',
            color: Colors.blue,
          )
        ],
      ),
    );
  }

  Widget _buildLamparaChart() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Existencias de Lámparas'),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          BarSeries<dynamic, String>(
            dataSource: _lamparas,
            xValueMapper: (dynamic data, _) => data['productoTerminado'],
            yValueMapper: (dynamic data, _) => data['existencia'],
            name: 'Existencias',
            color: Colors.green,
          )
        ],
      ),
    );
  }

  Widget _buildComponenteTable() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: SfDataGrid(
        source: ComponentesDataSource(_componentes),
        columns: <GridColumn>[
          GridColumn(columnName: 'id', label: Text('ID')),
          GridColumn(columnName: 'componente', label: Text('Componente')),
          GridColumn(columnName: 'existencia', label: Text('Existencia')),
        ],
      ),
    );
  }

  Widget _buildLamparaTable() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: SfDataGrid(
        source: LamparasDataSource(_lamparas),
        columns: <GridColumn>[
          GridColumn(columnName: 'id', label: Text('ID')),
          GridColumn(columnName: 'productoTerminado', label: Text('Lámpara')),
          GridColumn(columnName: 'existencia', label: Text('Existencia')),
        ],
      ),
    );
  }
}

class ComponentesDataSource extends DataGridSource {
  ComponentesDataSource(List<dynamic> componentes) {
    dataGridRows = componentes.map<DataGridRow>((dynamic componente) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: componente['id']),
        DataGridCell<String>(
            columnName: 'componente', value: componente['componente']),
        DataGridCell<int>(
            columnName: 'existencia', value: componente['existencia']),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[2].value.toString()),
      ),
    ]);
  }
}

class LamparasDataSource extends DataGridSource {
  LamparasDataSource(List<dynamic> lamparas) {
    dataGridRows = lamparas.map<DataGridRow>((dynamic lampara) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: lampara['id']),
        DataGridCell<String>(
            columnName: 'productoTerminado',
            value: lampara['productoTerminado']),
        DataGridCell<int>(
            columnName: 'existencia', value: lampara['existencia']),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[2].value.toString()),
      ),
    ]);
  }
}
