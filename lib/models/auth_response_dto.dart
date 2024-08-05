class AuthResponseDTO {
  final String token;
  final bool isSuccess;
  final String message;

  AuthResponseDTO({
    required this.token,
    required this.isSuccess,
    required this.message,
  });

  factory AuthResponseDTO.fromJson(Map<String, dynamic> json) {
    return AuthResponseDTO(
      token: json['token'],
      isSuccess: json['isSuccess'],
      message: json['message'],
    );
  }
}
