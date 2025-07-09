import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import '../models/paciente.dart';
import '../models/cita.dart';

class PdfGenerator {
  static Future<File> generarPdfConCita(Paciente paciente, Cita cita) async {
    final pdf = pw.Document();

    final Uint8List logoBytes = await rootBundle
        .load('assets/images/logo-hospital.png')
        .then((data) => data.buffer.asUint8List());
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    final robotoFont = pw.Font.ttf(
      await rootBundle
          .load('assets/fonts/Roboto-Regular.ttf')
          .then((value) => value.buffer.asByteData()),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(logoImage, width: 50, height: 50),
                pw.SizedBox(width: 10),
                pw.Text(
                  'Hospital de Brigada de Selva No.17 “Pastaza”',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    font: robotoFont,
                    color: PdfColor.fromHex('#0000FF'),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Center(
            child: pw.Text(
              'TURNO',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                font: robotoFont,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildLabelValueRow(
                  'No. IDENTIFICACIÓN:', paciente.identificacion, robotoFont),
              buildLabelValueRow('PACIENTE:', paciente.nombre, robotoFont),
              buildLabelValueRow('Médico:', cita.nombreMedico, robotoFont),
              buildLabelValueRow(
                  'Especialidad:', cita.especialidad, robotoFont),
              buildLabelValueRow(
                  'Tipo de Atención:', cita.tipoAtencion, robotoFont),
              buildLabelValueRow('Consultorio:', cita.consultorio, robotoFont),
              buildLabelValueRow(
                  'Celular Médico:', cita.celularMedico, robotoFont),
              buildLabelValueRow(
                  'Fecha del Turno:', cita.fechaTurno, robotoFont,
                  color: PdfColor.fromHex('#FF0000')),
              buildLabelValueRow(
                  'No. Turno:', cita.numeroTurno.toString(), robotoFont,
                  color: PdfColor.fromHex('#FF0000')),
              buildLabelValueRow('Hora del Turno:', cita.horaTurno, robotoFont,
                  color: PdfColor.fromHex('#FF0000')),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Favor asistir 20 minutos antes de su turno',
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: robotoFont,
                    color: PdfColor.fromHex('#FF0000'),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              buildLabelValueRow(
                  'Fecha creación:', cita.fechaCreacion, robotoFont),
            ],
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/cita_${cita.numeroTurno}.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static pw.Widget buildLabelValueRow(String label, String value, pw.Font font,
      {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 130, // Ancho fijo para la columna de etiquetas
            child: pw.Text(label, style: pw.TextStyle(font: font)),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(font: font, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
