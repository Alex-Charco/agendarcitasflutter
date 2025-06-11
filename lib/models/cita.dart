class Cita {
  final String fechaTurno;
  final String horaTurno;
  final String nombreMedico;
  final String especialidad;
  final String tipoAtencion;
  final String consultorio;
  final String estado;
  final String fechaCreacion;
  final int numeroTurno;

  Cita({
    required this.fechaTurno,
    required this.horaTurno,
    required this.nombreMedico,
    required this.especialidad,
    required this.tipoAtencion,
    required this.consultorio,
    required this.estado,
	required this.fechaCreacion,
    required this.numeroTurno,
  });

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      fechaTurno: json['datos_turno']['fecha_horario'],
      horaTurno: json['datos_turno']['hora_turno'],
      nombreMedico: json['datos_medico']['nombre'],
      especialidad: json['datos_especialidad']['nombre'],
      tipoAtencion: json['datos_especialidad']['atencion'],
      consultorio: json['datos_especialidad']['consultorio'],
      estado: json['datos_cita']['estado_cita'],
	  fechaCreacion: json['datos_cita']['fecha_creacion'],
      numeroTurno: json['datos_turno']['numero_turno'],
    );
  }
}
