class Cita {
  final String fechaTurno;
  final String horaTurno;
  final String nombreMedico;
  final String especialidad;
  final String tipoAtencion;
  final String consultorio;
  final String estado;

  Cita({
    required this.fechaTurno,
    required this.horaTurno,
    required this.nombreMedico,
    required this.especialidad,
    required this.tipoAtencion,
    required this.consultorio,
    required this.estado,
  });

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      fechaTurno: json['turno']['horario']['fecha_horario'],
      horaTurno: json['turno']['hora_turno'],
      nombreMedico: json['medico']['nombre'],
      especialidad: json['medico']['especialidad']['nombre'],
      tipoAtencion: json['medico']['especialidad']['atencion'],
      consultorio: json['medico']['especialidad']['consultorio'],
      estado: json['estado_cita'],
    );
  }
}
