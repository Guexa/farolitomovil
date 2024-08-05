class UpdateUserDTO {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String direccion;

  UpdateUserDTO({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.direccion,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'direccion': direccion,
    };
  }
}
