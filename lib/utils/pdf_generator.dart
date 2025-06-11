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
              pw.Text('No. IDENTIFICACIÓN:  ${paciente.identificacion}', style: pw.TextStyle(font: robotoFont)),
              pw.Text('PACIENTE:            ${paciente.nombre}', style: pw.TextStyle(font: robotoFont)),
              pw.Text('Médico:              ${cita.nombreMedico}', style: pw.TextStyle(font: robotoFont)),
              pw.Text('Especialidad:        ${cita.especialidad}', style: pw.TextStyle(font: robotoFont)),
              pw.Text('Tipo de Atención:    ${cita.tipoAtencion}', style: pw.TextStyle(font: robotoFont)),
              pw.Text('Consultorio:         ${cita.consultorio}', style: pw.TextStyle(font: robotoFont)),
              pw.Row(children: [
                pw.Text('Fecha del Turno:   ', style: pw.TextStyle(font: robotoFont)),
                pw.Text(cita.fechaTurno, style: pw.TextStyle(font: robotoFont, color: PdfColor.fromHex('#FF0000'))) 
              ]),
              pw.Row(children: [
                pw.Text('No. Turno:         ', style: pw.TextStyle(font: robotoFont)),
                pw.Text(cita.numeroTurno.toString(), style: pw.TextStyle(font: robotoFont, color: PdfColor.fromHex('#FF0000'))) 
              ]),
              pw.Row(children: [
                pw.Text('Hora del Turno:    ', style: pw.TextStyle(font: robotoFont)),
                pw.Text(cita.horaTurno, style: pw.TextStyle(font: robotoFont, color: PdfColor.fromHex('#FF0000'))) 
              ]),
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
              pw.Text('Fecha creación:  ${cita.fechaCreacion}', style: pw.TextStyle(font: robotoFont)),
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
}
