import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../models/cita.dart';
import '../models/paciente.dart';
import '../utils/pdf_generator.dart';

class CitaDataTable extends StatelessWidget {
  final List<Cita> citas;
  final Paciente paciente;

  const CitaDataTable({super.key, required this.citas, required this.paciente});

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
            color: Colors.white,
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
                  Text('No. Turno: ${cita.numeroTurno}'),
                  Text('Médico: ${cita.nombreMedico}'),
                  Text('Especialidad: ${cita.especialidad}'),
                  Text('Tipo Atención: ${cita.tipoAtencion}'),
                  Text('Consultorio: ${cita.consultorio}'),
                  Text('Estado: ${cita.estado}'),
                  Text('Fecha creación: ${cita.fechaCreacion}'),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Descargar PDF'),
                      onPressed: () async {
                        final pdfFile = await PdfGenerator.generarPdfConCita(paciente, cita);
                        await Printing.layoutPdf(
                          onLayout: (format) => pdfFile.readAsBytes(),
                          name: "cita_${cita.numeroTurno}.pdf",
                        );
                      },
                    ),
                  ),
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
          // ignore: deprecated_member_use
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.blueGrey.shade50),
          // ignore: deprecated_member_use
          dataRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.white),
          columns: const [
            DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Hora', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('No. Turno', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Médico', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Especialidad', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Tipo Atención', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Consultorio', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Fecha creación', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('PDF')),
          ],
          rows: citas.map((cita) {
            return DataRow(cells: [
              DataCell(Text(cita.fechaTurno)),
              DataCell(Text(cita.horaTurno)),
              DataCell(Text(cita.numeroTurno.toString())),
              DataCell(Text(cita.nombreMedico)),
              DataCell(Text(cita.especialidad)),
              DataCell(Text(cita.tipoAtencion)),
              DataCell(Text(cita.consultorio)),
              DataCell(Text(cita.estado)),
              DataCell(Text(cita.fechaCreacion)),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: 'Descargar PDF',
                  onPressed: () async {
                    final pdfFile = await PdfGenerator.generarPdfConCita(paciente, cita);
                    await Printing.layoutPdf(
                      onLayout: (format) => pdfFile.readAsBytes(),
                      name: "cita_${cita.numeroTurno}.pdf",
                    );
                  },
                ),
              ),
            ]);
          }).toList(),
        ),
      );
    }
  }
}
