class DetalleMermaComponenteDTO {
  final int id;
  final int? cantidad;
  final String descripcion;
  final DateTime? fecha;
  final String usuario;
  final String componente;

  DetalleMermaComponenteDTO({
    required this.id,
    this.cantidad,
    required this.descripcion,
    this.fecha,
    required this.usuario,
    required this.componente,
  });

  factory DetalleMermaComponenteDTO.fromJson(Map<String, dynamic> json) {
    return DetalleMermaComponenteDTO(
      id: json['id'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : null,
      usuario: json['usuario'],
      componente: json['componente'],
    );
  }
}
