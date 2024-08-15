class AgregarCompraDTO {
  final String fecha;
  final int proveedorId;
  final List<DetalleCompraDTO> detalles;

  AgregarCompraDTO({
    required this.fecha,
    required this.proveedorId,
    required this.detalles,
  });

  factory AgregarCompraDTO.fromJson(Map<String, dynamic> json) {
    return AgregarCompraDTO(
      fecha: json['fecha'],
      proveedorId: json['proveedorId'],
      detalles: List<DetalleCompraDTO>.from(
        json['detalles'].map((detalle) => DetalleCompraDTO.fromJson(detalle)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha,
      'proveedorId': proveedorId,
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
    };
  }
}

class DetalleCompraDTO {
  final int componentesId;
  final int cantidad;
  final double costo;
  final int proveedorId;

  DetalleCompraDTO(
      {required this.componentesId,
      required this.cantidad,
      required this.costo,
      required this.proveedorId});

  factory DetalleCompraDTO.fromJson(Map<String, dynamic> json) {
    return DetalleCompraDTO(
        componentesId: json['componentesId'],
        cantidad: json['cantidad'],
        costo: json['costo'],
        proveedorId: json['proveedorId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'componentesId': componentesId,
      'cantidad': cantidad,
      'costo': costo,
    };
  }
}
