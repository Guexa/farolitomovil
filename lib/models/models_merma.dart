class MermaComponente {
  final int id;
  final int cantidad;
  final String descripcion;
  final String fecha;
  final String usuario;
  final String componente;

  MermaComponente({
    required this.id,
    required this.cantidad,
    required this.descripcion,
    required this.fecha,
    required this.usuario,
    required this.componente,
  });

  factory MermaComponente.fromJson(Map<String, dynamic> json) {
    return MermaComponente(
      id: json['id'],
      cantidad: json['cantidad'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      usuario: json['usuario'],
      componente: json['componente'],
    );
  }
}
