class Compraview {
  final int id;
  final DateTime fecha;
  final String usuarioNombre;
  final List<DetalleCompraDTO> detalles;

  Compraview({
    required this.id,
    required this.fecha,
    required this.usuarioNombre,
    required this.detalles,
  });

  factory Compraview.fromJson(Map<String, dynamic> json) {
    return Compraview(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      usuarioNombre: json['usuarioNombre'],
      detalles: (json['detalles'] as List)
          .map((detalle) => DetalleCompraDTO.fromJson(detalle))
          .toList(),
    );
  }
}

class DetalleCompraDTO {
  final int id;
  final int cantidad;
  final double costo;
  final String nombreComponente;

  DetalleCompraDTO({
    required this.id,
    required this.cantidad,
    required this.costo,
    required this.nombreComponente,
  });

  factory DetalleCompraDTO.fromJson(Map<String, dynamic> json) {
    return DetalleCompraDTO(
      id: json['id'],
      cantidad: json['cantidad'],
      costo: json['costo'],
      nombreComponente: json['nombreComponente'],
    );
  }
}
