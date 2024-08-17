class Compraview {
  final String usuarioNombre;
  final List<Detalle> detalles;

  Compraview({
    required this.usuarioNombre,
    required this.detalles,
  });

  factory Compraview.fromJson(Map<String, dynamic> json) {
    return Compraview(
      usuarioNombre: json['usuarioNombre'],
      detalles:
          (json['detalles'] as List).map((i) => Detalle.fromJson(i)).toList(),
    );
  }
}

class Detalle {
  final String nombreComponente;
  final int cantidad;
  final double costo;

  Detalle({
    required this.nombreComponente,
    required this.cantidad,
    required this.costo,
  });

  factory Detalle.fromJson(Map<String, dynamic> json) {
    return Detalle(
      nombreComponente: json['nombreComponente'],
      cantidad: json['cantidad'],
      costo: (json['costo'] as num).toDouble(), // Convertir a double
    );
  }
}
