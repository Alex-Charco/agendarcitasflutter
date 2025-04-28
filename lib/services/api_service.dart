import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paciente_cita_response.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final String? baseUrl = dotenv.env['API_URL_GET_CITA'];

  static Future<PacienteCitaResponse> getCitasPorIdentificacion(String identificacion) async {
    if (baseUrl == null) {
      throw Exception('La URL base no está definida en el archivo .env');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no disponible. Debe iniciar sesión nuevamente.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/cita/get/paciente/$identificacion'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PacienteCitaResponse.fromJson(data);
    } else {
      throw Exception('Error al obtener citas: ${response.statusCode}');
    }
  }
}
