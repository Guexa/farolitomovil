import 'package:flutter/material.dart';
import 'package:farolitomovil/services/api_service.dart';
import 'package:farolitomovil/models/auth_response_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contrasenia.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //console.log("aqui inicia ");
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _usernameController.text;
    final password = _passwordController.text;

    final authResponse = await _apiService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (authResponse != null && authResponse.isSuccess) {
      // Save token and navigate to the next page
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', authResponse.token);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenido, $email!')),
      );

      Navigator.pushReplacementNamed(context, '/registroUsuario');
    } else {
      setState(() {
        _errorMessage = authResponse?.message ?? 'Error de autenticación';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.062),
                blurRadius: 40,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'Farolito',
                style: TextStyle(
                  fontSize: 2.5 * 16,
                  color: Color(0xFF2e2e2e),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildInputField(
                controller: _usernameController,
                hint: 'Usuario',
                icon: Icons.person,
                isPassword: false,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _passwordController,
                hint: 'Contraseña',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const ContraseniaPage(),
              //         ),
              //       );
              //     },
              //     child: const Text(
              //       '¿Olvidaste la contraseña?',
              //       style: TextStyle(
              //         color: Colors.blue,
              //         fontSize: 12,
              //         fontWeight: FontWeight.w500,
              //         decoration: TextDecoration.underline,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2e2e2e),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Ingresar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF505050),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF2e2e2e)),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(left: 30, bottom: 10),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFadadad)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFc772ff)),
        ),
      ),
    );
  }
}
