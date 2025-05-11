import 'package:flutter/material.dart';
import '../models/cita.dart';

class CitaDataTable extends StatelessWidget {
  final List<Cita> citas;

  const CitaDataTable({super.key, required this.citas});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (citas.isEmpty) {
      return const Center(child: Text('No hay citas disponibles'));
    }

    if (isMobile) {
      return ListView.builder(
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
                  Text('Fecha: ${cita.fechaTurno}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
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
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateColor.resolveWith(
              (states) => Colors.blueGrey.shade50),
          dataRowColor: WidgetStateColor.resolveWith(
              (states) => Colors.white),
          columns: const [
            DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Hora', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Médico', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Especialidad', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Tipo Atención', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Consultorio', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: citas.map((cita) {
            return DataRow(cells: [
              DataCell(Text(cita.fechaTurno)),
              DataCell(Text(cita.horaTurno)),
              DataCell(Text(cita.nombreMedico)),
              DataCell(Text(cita.especialidad)),
              DataCell(Text(cita.tipoAtencion)),
              DataCell(Text(cita.consultorio)),
              DataCell(Text(cita.estado)),
            ]);
          }).toList(),
        ),
      );
    }
  }
}
