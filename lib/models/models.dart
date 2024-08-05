class ComponenteConDetallesDTO {
  final int id;
  final String nombre;
  final int existencia;
  final List<InventarioComponenteDetalleDTO> detalles;

  ComponenteConDetallesDTO({
    required this.id,
    required this.nombre,
    required this.existencia,
    required this.detalles,
  });

  factory ComponenteConDetallesDTO.fromJson(Map<String, dynamic> json) {
    return ComponenteConDetallesDTO(
      id: json['id'],
      nombre: json['nombre'],
      existencia: json['existencia'],
      detalles: (json['detalles'] as List)
          .map((i) => InventarioComponenteDetalleDTO.fromJson(i))
          .toList(),
    );
  }
}

class InventarioComponenteDetalleDTO {
  final int id;
  final int? cantidad;
  final String proveedorNombre;
  final DateTime fechaCompra;

  InventarioComponenteDetalleDTO({
    required this.id,
    this.cantidad,
    required this.proveedorNombre,
    required this.fechaCompra,
  });

  factory InventarioComponenteDetalleDTO.fromJson(Map<String, dynamic> json) {
    return InventarioComponenteDetalleDTO(
      id: json['id'],
      cantidad: json['cantidad'],
      proveedorNombre: json['proveedorNombre'],
      fechaCompra: DateTime.parse(json['fechaCompra']),
    );
  }
}
