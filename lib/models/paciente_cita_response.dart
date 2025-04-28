import 'paciente.dart';
import 'cita.dart';

class PacienteCitaResponse {
  final Paciente paciente;
  final List<Cita> citas;

  PacienteCitaResponse({
    required this.paciente,
    required this.citas,
  });

  factory PacienteCitaResponse.fromJson(Map<String, dynamic> json) {
    return PacienteCitaResponse(
      paciente: Paciente.fromJson(json['paciente']),
      citas: List<Cita>.from(json['citas'].map((cita) => Cita.fromJson(cita))),
    );
  }
}
