// lib/features/auth/data/services/user_api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_dto.dart';

class UserApiService {
  String get baseUrl {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return "http://localhost:8080/api/users";
    }
    return "http://10.0.2.2:8080/api/users";
  }

  Future<UserDto> signup(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/signup"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return UserDto.fromJson(jsonDecode(res.body));
  }

  Future<UserDto> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Login failed: ${res.statusCode}');
    }
    return UserDto.fromJson(jsonDecode(res.body));
  }
}
