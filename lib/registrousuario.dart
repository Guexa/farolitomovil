import 'package:flutter/material.dart';

class RegistroUsuarioPage extends StatelessWidget {
  const RegistroUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farolito'),
        automaticallyImplyLeading: false, // Esto oculta la flecha de retroceso
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Hola',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Almacén',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        onTap: (int index) {
          print("BottomNavigationBar item tapped: $index");
        },
      ),
    );
  }
}
