// lib/features/auth/data/models/user_dto.dart

class UserDto {
  final int? id;
  final String email;
  final String? password;

  UserDto({
    this.id,
    required this.email,
    this.password,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
}
