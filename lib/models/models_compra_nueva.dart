// class Proveedor {
//   final String id;
//   final String nombre;

//   Proveedor({required this.id, required this.nombre});

//   factory Proveedor.fromJson(Map<String, dynamic> json) {
//     return Proveedor(
//       id: json['id'],
//       nombre: json['nombre'],
//     );
//   }
// }

// class Componente {
//   final String id;
//   final String nombre;

//   Componente({required this.id, required this.nombre});

//   factory Componente.fromJson(Map<String, dynamic> json) {
//     return Componente(
//       id: json['id'],
//       nombre: json['nombre'],
//     );
//   }
// }

// class DetalleCompra {
//   final String componente;
//   final int cantidad;
//   final double costo;

//   DetalleCompra({
//     required this.componente,
//     required this.cantidad,
//     required this.costo,
//   });
// }

// class DetalleCompraDTO {
//   final String componentesId;
//   final int cantidad;
//   final double costo;

//   DetalleCompraDTO({
//     required this.componentesId,
//     required this.cantidad,
//     required this.costo,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'componentesId': componentesId,
//       'cantidad': cantidad,
//       'costo': costo,
//     };
//   }
// }

// class AgregarCompraDTO {
//   final String proveedorId;
//   final List<DetalleCompraDTO> detalles;

//   AgregarCompraDTO({
//     required this.proveedorId,
//     required this.detalles,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'proveedorId': proveedorId,
//       'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
//     };
//   }
// }

import 'dart:convert';

class Proveedor {
  final int id;
  final String nombreEmpresa;
  final String direccion;
  final String telefono;
  final String nombreAtiende;
  final String apellidoM;
  final String apellidoP;
  final bool estatus;
  final List<Producto> productos;

  Proveedor({
    required this.id,
    required this.nombreEmpresa,
    required this.direccion,
    required this.telefono,
    required this.nombreAtiende,
    required this.apellidoM,
    required this.apellidoP,
    required this.estatus,
    required this.productos,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'],
      nombreEmpresa: json['nombreEmpresa'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      nombreAtiende: json['nombreAtiende'],
      apellidoM: json['apellidoM'],
      apellidoP: json['apellidoP'],
      estatus: json['estatus'],
      productos:
          (json['productos'] as List).map((p) => Producto.fromJson(p)).toList(),
    );
  }
}

class Componente {
  final int id;
  final String nombre;

  Componente({
    required this.id,
    required this.nombre,
  });

  factory Componente.fromJson(Map<String, dynamic> json) {
    return Componente(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

class Producto {
  final int id;
  final String nombre;

  Producto({
    required this.id,
    required this.nombre,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}
