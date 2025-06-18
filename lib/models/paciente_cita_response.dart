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
	  final citasJson = json['citas'] as List<dynamic>? ?? [];

	  return PacienteCitaResponse(
		paciente: Paciente.fromJson(json['paciente']),
		citas: citasJson.map((cita) => Cita.fromJson(cita)).toList(),
	  );
	}
}
