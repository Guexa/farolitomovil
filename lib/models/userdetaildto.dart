class UserDetailDTO {
  final String? id;
  final String? fullName;
  final String? email;
  final String? tarjeta;
  final List<String>? roles;
  final String? phoneNumber;
  final bool twoFactorEnabled;
  final bool phoneNumberConfirmed;
  final int accessFailedCount;
  final String? urlImage;
  final String? direccion;

  UserDetailDTO({
    this.id,
    this.fullName,
    this.email,
    this.tarjeta,
    this.roles,
    this.phoneNumber,
    required this.twoFactorEnabled,
    required this.phoneNumberConfirmed,
    required this.accessFailedCount,
    this.urlImage,
    this.direccion,
  });

  factory UserDetailDTO.fromJson(Map<String, dynamic> json) {
    return UserDetailDTO(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      tarjeta: json['tarjeta'],
      roles: List<String>.from(json['roles'] ?? []),
      phoneNumber: json['phoneNumber'],
      twoFactorEnabled: json['twoFactorEnabled'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      accessFailedCount: json['accessFailedCount'],
      urlImage: json['urlImage'],
      direccion: json['direccion'],
    );
  }
}
