import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paciente_cita_response.dart';
import '../models/turno.dart';
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

  // Obtener turnos disponibles
  static Future<List<Turno>> getTurnos() async {
    if (baseUrl == null) {
      throw Exception('La URL base no está definida en el archivo .env');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no disponible. Debe iniciar sesión nuevamente.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/turno/get/disponibles'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Turno.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener turnos: ${response.statusCode}');
    }
  }

  // Registrar cita
  static Future<void> registrarCita(int idTurno) async {
    if (baseUrl == null) {
      throw Exception('La URL base no está definida en el archivo .env');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userJson = prefs.getString('user');

    if (token == null || userJson == null) {
      throw Exception('Token o información de usuario no disponible');
    }

    final user = jsonDecode(userJson);
    final idPaciente = user['id_paciente'];

    if (idPaciente == null) {
      throw Exception('ID del paciente no disponible');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/cita/registrar'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_turno': idTurno,
        'id_paciente': idPaciente,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al registrar cita: ${response.statusCode}');
    }
  }
}
