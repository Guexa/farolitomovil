class MermaComponenteDTO {
  final int cantidad;
  final String descripcion;
  final int inventarioComponenteId;

  MermaComponenteDTO({
    required this.cantidad,
    required this.descripcion,
    required this.inventarioComponenteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'cantidad': cantidad,
      'descripcion': descripcion,
      'inventarioComponenteId': inventarioComponenteId,
    };
  }
}
