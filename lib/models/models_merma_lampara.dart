class MermaLampara {
  final int id;
  final int cantidad;
  final String descripcion;
  final String fecha;
  final String usuario;
  final String lampara;

  MermaLampara({
    required this.id,
    required this.cantidad,
    required this.descripcion,
    required this.fecha,
    required this.usuario,
    required this.lampara,
  });

  factory MermaLampara.fromJson(Map<String, dynamic> json) {
    return MermaLampara(
      id: json['id'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      usuario: json['usuario'],
      lampara: json['lampara'],
    );
  }
}
