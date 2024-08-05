import 'package:flutter/material.dart';
import 'package:farolitomovil/services/api_service_user.dart';
import 'package:farolitomovil/models/userdetaildto.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  UserDetailDTO? _userDetail;
  bool _isLoading = true;
  final String baseUrl =
      'https://st4.depositphotos.com/11574170/25191/v/450/depositphotos_251916955-stock-illustration-user-glyph-color-icon.jpg';
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final apiService = ApiService();
    final userDetail = await apiService.getUserDetails();
    setState(() {
      _userDetail = userDetail;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _userDetail?.urlImage != null
        ? '$baseUrl${_userDetail?.urlImage}'
        : 'https://static.vecteezy.com/system/resources/previews/008/844/895/non_2x/user-icon-design-free-png.png';

    print('Image URL: $imageUrl');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFC99838),
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _userDetail == null
                ? Text('Error al cargar los datos del usuario.')
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
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
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          const SizedBox(height: 20),
                          _buildProfileField(
                            label: 'Email',
                            value: _userDetail?.email ?? '',
                            icon: Icons.email,
                            id: 'email',
                          ),
                          _buildProfileField(
                            label: 'Fullname',
                            value: _userDetail?.fullName ?? '',
                            icon: Icons.person,
                            id: 'fullname',
                          ),
                          _buildProfileField(
                            label: 'Dirección',
                            value: _userDetail?.direccion ?? '',
                            icon: Icons.location_on,
                            id: 'direccion',
                          ),
                          _buildProfileField(
                            label: 'Tarjeta',
                            value: _userDetail?.tarjeta ?? '',
                            icon: Icons.credit_card,
                            id: 'tarjeta',
                          ),
                          _buildProfileField(
                            label: 'Roles',
                            value: _userDetail?.roles?.join(', ') ?? '',
                            icon: Icons.work,
                            id: 'roles',
                          ),
                          _buildProfileField(
                            label: 'Número',
                            value: _userDetail?.phoneNumber ?? '',
                            icon: Icons.phone,
                            id: 'numero',
                          ),
                          _buildProfileField(
                            label: 'PhoneNumber',
                            value: _userDetail?.phoneNumber ?? '',
                            icon: Icons.phone_android,
                            id: 'phone_number',
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required IconData icon,
    required String id,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  key: Key(id),
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
