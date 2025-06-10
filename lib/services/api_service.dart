import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paciente_cita_response.dart';
import '../models/turno.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agendarcitasflutter/utils/dialog_utils.dart';

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

  print('Base URL: $baseUrl');
  print('Endpoint: $baseUrl/api/turno/get/disponibles');

  final response = await http.get(
    Uri.parse('$baseUrl/api/turno/get/disponibles'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body); // 👈 Esto es un Map
    final turnos = data['turnos'] as List;  // 👈 Sacamos solo la lista
    return turnos.map((e) => Turno.fromJson(e)).toList(); // 👈 Mapeamos
  } else {
    throw Exception('Error al obtener turnos: ${response.statusCode}');
  }
}


  // Registrar cita
  static Future<void> registrarCita(BuildContext context, int idTurno) async {
    if (baseUrl == null) {
      showErrorDialog(context, 'Error', 'URL de API no configurada.');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userJson = prefs.getString('user');

    if (token == null || userJson == null) {
      // ignore: use_build_context_synchronously
      showErrorDialog(context, 'Sesión expirada', 'Inicia sesión nuevamente.');
      throw Exception('Sesión expirada');
    }

    final user = jsonDecode(userJson);
    final idPaciente = user['id_paciente'];

    if (idPaciente == null) {
      // ignore: use_build_context_synchronously
      showErrorDialog(
          context, 'Error', 'Información de paciente no disponible');
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      showSuccessDialog(context, 'Éxito', 'Cita registrada con éxito');
      print('Status code: ${response.statusCode}');
      return;
    } else if (response.statusCode == 409) {
      // ignore: use_build_context_synchronously
      showErrorDialog(
          context, 'Conflicto', 'Ya tienes una cita registrada para ese día');
      throw Exception('Conflicto de cita');
    } else if (response.statusCode == 401) {
      // ignore: use_build_context_synchronously
      showErrorDialog(context, 'Sesión caducada', 'Por favor inicia sesión.');
      throw Exception('Token expirado');
    } else {
      print('Entró en bloque de error - status: ${response.statusCode}');
      String mensajeError = 'Error al registrar la cita.';

      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['message'] != null) {
          mensajeError = decoded['message'];
          mensajeError =
              mensajeError.replaceAll('❌ Error en registrarCita: ', '');
        } else if (decoded is String) {
          mensajeError = decoded;
        }
        print('Response body: ${response.body}');
      } catch (_) {
        print('No se pudo decodificar el cuerpo de la respuesta');
      }

      // ignore: use_build_context_synchronously
      showErrorDialog(context, 'No se pudo registrar la cita', mensajeError);
      throw Exception('Error en registrarCita: $mensajeError');
    }
  }
}
