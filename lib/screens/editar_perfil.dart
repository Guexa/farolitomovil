import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:io';
import 'package:farolitomovil/services/api_service_user.dart';
import 'package:farolitomovil/services/api_service_update_user.dart';
import 'package:farolitomovil/models/models_update_user_dto.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  // File? _image;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    final apiService = ApiService();
    final userDetail = await apiService.getUserDetails();

    if (userDetail != null) {
      _nombreController.text = userDetail.fullName ?? '';
      _emailController.text = userDetail.email ?? '';
      _telefonoController.text = userDetail.phoneNumber ?? '';
      _direccionController.text = userDetail.direccion ?? '';
      setState(() {});
    }
  }

  void _onChanged() {
    setState(() {
      _hasChanged = true;
    });
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? pickedImage =
  //       await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedImage != null) {
  //     setState(() {
  //       _image = File(pickedImage.path);
  //       _onChanged();
  //     });
  //   }
  // }

  Future<void> _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final apiService = ApiServiceUpdateUser();

      final updateUserDto = UpdateUserDTO(
        fullName: _nombreController.text,
        email: _emailController.text,
        phoneNumber: _telefonoController.text,
        direccion: _direccionController.text,
      );

      final success = await apiService.updateUserDetails(updateUserDto);

      if (success) {
        // if (_image != null) {
        //   final imageUploadSuccess = await apiService.uploadUserImage(_image!);
        //   if (!imageUploadSuccess) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Error al subir la imagen')),
        //     );
        //   }
        // }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Información guardada correctamente')),
        );
        setState(() {
          _hasChanged = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la información')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String id,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon),
          helperText: 'Ingrese su $labelText',
          errorText: controller.text.isEmpty
              ? 'Ingrese información a este campo'
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        key: Key(id),
        onChanged: (value) => _onChanged(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingrese información a este campo';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFC99838),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0,
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                      // children: [
                      //   CircleAvatar(
                      //     radius: 50,
                      //     backgroundImage: _image == null
                      //         ? NetworkImage(
                      //             'https://via.placeholder.com/150') // Imagen de placeholder
                      //         : FileImage(_image!) as ImageProvider,
                      //   ),
                      //   Positioned(
                      //     bottom: 0,
                      //     right: 0,
                      //     child: IconButton(
                      //       icon:
                      //           const Icon(Icons.camera_alt, color: Colors.white),
                      //       onPressed: _pickImage,
                      //     ),
                      //   ),
                      // ],
                      ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                    id: 'email',
                  ),
                  _buildTextField(
                    controller: _nombreController,
                    labelText: 'Fullname',
                    icon: Icons.person,
                    id: 'fullname',
                  ),
                  _buildTextField(
                    controller: _telefonoController,
                    labelText: 'PhoneNumber',
                    icon: Icons.phone_android,
                    id: 'phone_number',
                  ),
                  _buildTextField(
                    controller: _direccionController,
                    labelText: 'Dirección',
                    icon: Icons.location_on,
                    id: 'direccion',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _hasChanged ? _onSave : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasChanged
                          ? const Color(0xFF0C4AAD)
                          : const Color(0xFFCFF9FC),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
