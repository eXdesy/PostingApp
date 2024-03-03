/// Clase UserDTO que representa un objeto de transferencia de datos (DTO) para los usuarios.
class UserDTO {
  int? userId;
  String userName;
  String email;
  String description;
  DateTime creationDate;
  String? password;

  /// Constructor de la clase UserDTO.
  UserDTO({
    this.userId,
    required this.userName,
    required this.email,
    required this.description,
    required this.creationDate,
    this.password,
  });

  /// Método que convierte un objeto UserDTO a un mapa de datos.
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      description: json['description'],
      creationDate: DateTime.parse(json['creationDate'] as String),
      password: json['password'],
    );
  }
}

