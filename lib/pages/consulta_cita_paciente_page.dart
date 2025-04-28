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
      String? userJson = prefs.getString('user'); // 🔥 Buscar los datos del user guardados

      if (userJson == null) {
        throw Exception('No se encontró la información del usuario.');
      }

      final userData = json.decode(userJson);
      String identificacionPaciente = userData['identificacion']; // 👈 Aquí se saca

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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Paciente: ${paciente!.nombre}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Identificación: ${paciente!.identificacion}'),
                                  Text('Correo: ${paciente!.correo}'),
                                  Text('Edad: ${paciente!.edad} años'),
                                  Text('Grupo Etario: ${paciente!.grupoEtario}'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          citas.isEmpty
                              ? const Center(child: Text('No hay citas disponibles'))
                              : isMobile
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: citas.length,
                                      itemBuilder: (context, index) {
                                        final cita = citas[index];
                                        return Card(
                                          elevation: 3,
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Fecha: ${cita.fechaTurno}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                Text('Hora: ${cita.horaTurno}'),
                                                Text('Médico: ${cita.nombreMedico}'),
                                                Text('Especialidad: ${cita.especialidad}'),
                                                Text('Tipo Atención: ${cita.tipoAtencion}'),
                                                Text('Consultorio: ${cita.consultorio}'),
                                                Text('Estado: ${cita.estado}'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                        child: DataTable(
                                          headingRowColor: WidgetStateColor.resolveWith((states) => Colors.blueGrey.shade50),
                                          dataRowColor: WidgetStateColor.resolveWith((states) => Colors.white),
                                          columns: const [
                                            DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('Hora', style: TextStyle(fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('Médico', style: TextStyle(fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('Especialidad', style: TextStyle(fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('Tipo Atención', style: TextStyle(fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('Consultorio', style: TextStyle(fontWeight: FontWeight.bold))),
                                            DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
                                          ],
                                          rows: citas.map((cita) => DataRow(
                                            cells: [
                                              DataCell(Text(cita.fechaTurno)),
                                              DataCell(Text(cita.horaTurno)),
                                              DataCell(Text(cita.nombreMedico)),
                                              DataCell(Text(cita.especialidad)),
                                              DataCell(Text(cita.tipoAtencion)),
                                              DataCell(Text(cita.consultorio)),
                                              DataCell(Text(cita.estado)),
                                            ],
                                          )).toList(),
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  );
                },
              ),

    );
  }
}
