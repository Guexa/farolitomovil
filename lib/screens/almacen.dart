import 'package:flutter/material.dart';
import 'inventario_componentes.dart';
import 'inventario_lamparas.dart';

class Almacen extends StatelessWidget {
  final Function(Widget) onSelectPage;

  Almacen({required this.onSelectPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFC99838),
        title: const Text(
          'Almacén',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          color:
              Color.fromARGB(255, 237, 236, 234), // Color del contenedor gris
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      onSelectPage(InventarioComponentes());
                    },
                    child: Text(
                      'Inventario Componentes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold, // Letra en negrita
                        color: Colors.white, // Letra blanca
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.black, // Color negro del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Esquinas cuadradas
                        side: BorderSide(
                            color: Colors.white, width: 2), // Contorno blanco
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      onSelectPage(InventarioLamparas());
                    },
                    child: Text(
                      'Inventario Lámparas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold, // Letra en negrita
                        color: Colors.white, // Letra blanca
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.black, // Color negro del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Esquinas cuadradas
                        side: BorderSide(
                            color: Colors.white, width: 2), // Contorno blanco
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
