import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/principal.dart';
import 'screens/contrasenia.dart'; // Importa la página de restablecimiento de contraseña

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farolito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/registroUsuario': (context) => const PrincipalPage(),
        '/contrasenia': (context) =>
            const ContraseniaPage(), // Añadir la ruta para la página de restablecimiento de contraseña
      },
    );
  }
}
