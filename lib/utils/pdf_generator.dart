import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import '../models/paciente.dart';
import '../models/cita.dart';

class PdfGenerator {
  static Future<File> generarPdfConCita(Paciente paciente, Cita cita) async {
    final pdf = pw.Document();

    // Cargar imagen del logo
    final Uint8List logoBytes = await rootBundle
        .load('assets/images/logo-hospital.png')
        .then((data) => data.buffer.asUint8List());
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    // Cargar fuente Roboto
    final robotoFont = pw.Font.ttf(
      await rootBundle
          .load('assets/fonts/Roboto-Regular.ttf')
          .then((value) => value.buffer.asByteData()),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(logoImage, width: 50, height: 50),
              pw.SizedBox(width: 10),
              pw.Text(
                'HB 17 PASTAZA',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  font: robotoFont,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'TURNO',
            style: pw.TextStyle(fontSize: 18, font: robotoFont),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Nombre: ${paciente.nombre}',
            style: pw.TextStyle(font: robotoFont),
          ),
          pw.Text(
            'Identificación: ${paciente.identificacion}',
            style: pw.TextStyle(font: robotoFont),
          ),
          pw.SizedBox(height: 20),
          // ignore: deprecated_member_use
          pw.Table.fromTextArray(
            headers: [
              'Fecha',
              'Hora',
              'No. Turno',
              'Médico',
              'Especialidad',
              'Tipo Atención',
              'Consultorio',
              'Estado',
              'Fecha creación'
            ],
            data: [
              [
                cita.fechaTurno,
                cita.horaTurno,
                cita.numeroTurno.toString(),
                cita.nombreMedico,
                cita.especialidad,
                cita.tipoAtencion,
                cita.consultorio,
                cita.estado,
                cita.fechaCreacion,
              ]
            ],
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: robotoFont,
            ),
            cellStyle: pw.TextStyle(font: robotoFont),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/cita_${cita.numeroTurno}.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
