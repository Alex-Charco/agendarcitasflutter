class Turno {
  final int idTurno;
  final String fecha;
  final String hora;
  final String estado;
  final Medico medico;

  Turno({
    required this.idTurno,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.medico,
  });

  factory Turno.fromJson(Map<String, dynamic> json) {
    return Turno(
      idTurno: json['id_turno'],
      fecha: json['fecha'],
      hora: json['hora'],
      estado: json['estado'],
      medico: Medico.fromJson(json['medico']),
    );
  }
}

class Medico {
  final String medico;
  final String especialidad;
  final String atencion;
  final String consultorio;

  Medico({
    required this.medico,
    required this.especialidad,
    required this.atencion,
    required this.consultorio,
  });

  factory Medico.fromJson(Map<String, dynamic> json) {
    final especialidad = json['Especialidad'];
    return Medico(
      medico: json['medico'],
      especialidad: especialidad['especialidad'],
      atencion: especialidad['atencion'],
      consultorio: especialidad['consultorio'],
    );
  }
}
