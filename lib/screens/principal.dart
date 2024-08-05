import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'perfil.dart';
import 'almacen.dart';
import 'dashboard_almacen.dart';
import 'login.dart';
import 'editar_perfil.dart';
import 'inventario_componentes.dart';
import 'inventario_lamparas.dart';
import 'compras.dart';
import 'merma.dart';
// import 'merma_componentes_usuario.dart';
// import 'merma_lamparas_usuario.dart';
import 'package:farolitomovil/services/api_service_user.dart';
import 'package:farolitomovil/models/userdetaildto.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  int _selectedIndex = 0;
  Widget? _activePage;
  UserDetailDTO? _userDetail;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _activePage = _getScreenForIndex(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _activePage = _getScreenForIndex(_selectedIndex);
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final apiService = ApiService();
    final userDetail = await apiService.getUserDetails();
    setState(() {
      _userDetail = userDetail;
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? const Color(0xFFFFF700) : Colors.white,
      ),
      label: label,
      backgroundColor: Colors.black,
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return DashboardAlmacen();
      case 1:
        return Almacen(onSelectPage: _onSelectPage);
      case 2:
        return Compras(onSelectPage: _onSelectPage);
      case 3:
        return MermaPage(onSelectPage: _onSelectPage);
      default:
        return Center(child: Text('Hola'));
    }
  }

  void _onSelectPage(Widget page) {
    setState(() {
      _activePage = page;
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cerrar sesión'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'Farolito',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: _activePage,
      drawer: CustomDrawer(
        userDetail: _userDetail,
        onSelectItem: _onSelectPage,
        onLogout: _confirmLogout,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          _buildBottomNavigationBarItem(Icons.bar_chart, 'Dashboard', 0),
          _buildBottomNavigationBarItem(Icons.store, 'Almacén', 1),
          _buildBottomNavigationBarItem(Icons.shopping_cart, 'Compras', 2),
          _buildBottomNavigationBarItem(Icons.trending_down, 'Merma', 3),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFFF700),
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final UserDetailDTO? userDetail;
  final Function(Widget) onSelectItem;
  final VoidCallback onLogout;

  CustomDrawer({
    required this.userDetail,
    required this.onSelectItem,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userDetail?.fullName ?? 'Nombre de Usuario'),
            accountEmail: Text(userDetail?.email ?? 'correo@ejemplo.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  userDetail?.urlImage ?? 'https://via.placeholder.com/150'),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ExpansionTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Ver perfil'),
                onTap: () {
                  onSelectItem(PerfilPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar perfil'),
                onTap: () {
                  onSelectItem(EditarPerfilPage());
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
