import 'package:agendarcitasflutter/widgets/cita_data_table.dart';
import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../models/cita.dart';
import '../models/paciente_cita_response.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ConsultaCitaPacientePage extends StatefulWidget {
  const ConsultaCitaPacientePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConsultaCitaPacientePageState createState() =>
      _ConsultaCitaPacientePageState();
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
      String? userJson =
          prefs.getString('user'); // 🔥 Buscar los datos del user guardados

      if (userJson == null) {
        throw Exception('No se encontró la información del usuario.');
      }

      final userData = json.decode(userJson);
      String identificacionPaciente =
          userData['identificacion']; // 👈 Aquí se saca

      PacienteCitaResponse response =
          await ApiService.getCitasPorIdentificacion(identificacionPaciente);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Citas'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : paciente == null
                  ? const Center(child: Text('No se encontró paciente'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          paciente!.nombre,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                            'Identificación: ${paciente!.identificacion}'),
                                        Text('Correo: ${paciente!.correo}'),
                                        Text('Edad: ${paciente!.edad} años'),
                                        Text(
                                            'Grupo Etario: ${paciente!.grupoEtario}'),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CitaDataTable(citas: citas),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
