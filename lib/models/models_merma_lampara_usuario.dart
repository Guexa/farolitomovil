class DetalleMermaLamparaDTO {
  final int id;
  final int? cantidad;
  final String descripcion;
  final DateTime? fecha;
  final String? usuario;
  final String? lampara;

  DetalleMermaLamparaDTO({
    required this.id,
    this.cantidad,
    required this.descripcion,
    this.fecha,
    this.usuario,
    this.lampara,
  });

  factory DetalleMermaLamparaDTO.fromJson(Map<String, dynamic> json) {
    return DetalleMermaLamparaDTO(
      id: json['id'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : null,
      usuario: json['usuario'],
      lampara: json['lampara'],
    );
  }
}
