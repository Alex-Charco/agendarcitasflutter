import 'package:agendarcitasflutter/services/api_service.dart';
import 'package:agendarcitasflutter/widgets/cita_data_table.dart';
import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../models/cita.dart';
import '../models/paciente_cita_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ConsultaCitaPacientePage extends StatefulWidget {
  const ConsultaCitaPacientePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConsultaCitaPacientePageState createState() => _ConsultaCitaPacientePageState();
}

class _ConsultaCitaPacientePageState extends State<ConsultaCitaPacientePage> {
  Paciente? paciente;
  List<Cita> citas = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');

      if (userJson == null) {
        throw Exception('No se encontró la información del usuario.');
      }

      final userData = json.decode(userJson);
      String identificacionPaciente = userData['identificacion'];

      PacienteCitaResponse response = await ApiService.getCitasPorIdentificacion(identificacionPaciente);

      setState(() {
        paciente = response.paciente;
        citas = response.citas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text('Error: $errorMessage'));
    }

    if (paciente == null) {
      return const Center(child: Text('No se encontró paciente'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            color: const Color.fromARGB(255, 243, 244, 246), // Fondo gris claro como el diseño de referencia
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paciente!.nombre,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Identificación: ${paciente!.identificacion}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: CitaDataTable(citas: citas, paciente: paciente!,),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 244, 246), // Fondo principal igual que diseño referencia
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 241, 245), // Mismo fondo gris claro del app bar
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Consulta de Citas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _buildBody(),
    );
  }
}
