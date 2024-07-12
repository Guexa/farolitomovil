import 'package:flutter/material.dart';

class RegistroUsuarioPage extends StatelessWidget {
  const RegistroUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farolito'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Asegúrate de que el nombre y la ubicación del archivo sean correctos
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
            icon: Icon(Icons.restaurant_menu),
            label: 'Dasaborh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Almacén',
          ),
        ],
        currentIndex: 0, // Set the selected index as needed
        selectedItemColor: Colors.deepPurple,
        onTap: (int index) {
          // Handle item tap here
          print("BottomNavigationBar item tapped: $index");
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Registro de Usuarios',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const RegisterForm(),
//     );
//   }
// }

// class RegisterForm extends StatefulWidget {
//   const RegisterForm({super.key});

//   @override
//   State<RegisterForm> createState() => _RegisterFormState();
// }

// class _RegisterFormState extends State<RegisterForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nombreController = TextEditingController();
//   final TextEditingController _apellidoController = TextEditingController();
//   final TextEditingController _direccionController = TextEditingController();
//   final TextEditingController _telefonoController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _rolController = TextEditingController();

//   @override
//   void dispose() {
//     _nombreController.dispose();
//     _apellidoController.dispose();
//     _direccionController.dispose();
//     _telefonoController.dispose();
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _rolController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Registro de Usuarios'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Registro de Usuarios',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Ingresa los datos del cliente para su registro.',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                               child: _buildInputField(
//                                   _nombreController, 'Nombre')),
//                           const SizedBox(width: 10),
//                           Expanded(
//                               child: _buildInputField(
//                                   _apellidoController, 'Apellido')),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                               child: _buildInputField(
//                                   _direccionController, 'Dirección')),
//                           const SizedBox(width: 10),
//                           Expanded(
//                               child: _buildInputField(
//                                   _usernameController, 'Username')),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                               child: _buildInputField(
//                                   _telefonoController, 'Teléfono')),
//                           const SizedBox(width: 10),
//                           Expanded(
//                               child:
//                                   _buildInputField(_emailController, 'Email')),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                               child: _buildInputField(
//                                   _passwordController, 'Password',
//                                   isPassword: true)),
//                           const SizedBox(width: 10),
//                           Expanded(
//                               child: _buildInputField(_rolController, 'Rol')),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             // Implement your form submission logic here
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'Enviar Registro',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(TextEditingController controller, String label,
//       {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Por favor ingresa $label';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
