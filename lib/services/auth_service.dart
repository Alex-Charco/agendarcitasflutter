import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paciente_cita_response.dart';
import '../models/turno.dart';
import 'storage_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String urlLogin,
  }) async {
    final response = await _client.post(
      Uri.parse(urlLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre_usuario': username,
        'password': password,
      }),
    );

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String urlReset,
  }) async {
    final response = await _client.post(
      Uri.parse(urlReset),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    return _processResponse(response);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }
}
