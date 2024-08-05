class RecetaConDetallesDTO {
  final int id;
  final String nombrelampara;
  final int existencias;
  final double costo;
  final String? urlImage;
  final List<InventarioLamparaDetalleDTO> detalles;

  RecetaConDetallesDTO({
    required this.id,
    required this.nombrelampara,
    required this.existencias,
    required this.costo,
    this.urlImage,
    required this.detalles,
  });

  factory RecetaConDetallesDTO.fromJson(Map<String, dynamic> json) {
    return RecetaConDetallesDTO(
      id: json['id'],
      nombrelampara: json['nombrelampara'],
      existencias: json['existencias'],
      costo: json['costo'],
      urlImage: json['urlImage'],
      detalles: (json['detalles'] as List)
          .map((detalle) => InventarioLamparaDetalleDTO.fromJson(detalle))
          .toList(),
    );
  }
}

class InventarioLamparaDetalleDTO {
  final int id;
  final DateTime fechaProduccion;
  final String usuario;
  final int cantidad;
  final double precio;

  InventarioLamparaDetalleDTO({
    required this.id,
    required this.fechaProduccion,
    required this.usuario,
    required this.cantidad,
    required this.precio,
  });

  factory InventarioLamparaDetalleDTO.fromJson(Map<String, dynamic> json) {
    return InventarioLamparaDetalleDTO(
      id: json['id'],
      fechaProduccion: DateTime.parse(json['fechaProduccion']),
      usuario: json['usuario'],
      cantidad: json['cantidad'],
      precio: json['precio'],
    );
  }
}
