import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final String userPhotoUrl;
  final Function(String) onNavigate;

  CustomDrawer({
    required this.userName,
    required this.userEmail,
    required this.userRole,
    required this.userPhotoUrl,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.black, // Fondo color negro
            height: 250, // Altura del DrawerHeader ajustada
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Centrar el contenido horizontalmente
              children: [
                CircleAvatar(
                  radius: 50, // Tamaño de la imagen
                  backgroundImage: NetworkImage(userPhotoUrl),
                ),
                SizedBox(height: 16),
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22, // Tamaño de fuente ajustado
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16, // Tamaño de fuente ajustado
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  userRole,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16, // Tamaño de fuente ajustado
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.file_upload),
                  title: Text('Subir foto'),
                  onTap: () {
                    // Acción al hacer clic
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Editar perfil'),
                  onTap: () => onNavigate('/perfil'),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Cerrar sesión'),
                  onTap: () {
                    // Acción al hacer clic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
