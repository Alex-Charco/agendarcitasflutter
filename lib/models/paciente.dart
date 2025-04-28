class Paciente {
  final int id;
  final String identificacion;
  final String nombre;
  final String correo;
  final int edad;
  final String grupoEtario;

  Paciente({
    required this.id,
    required this.identificacion,
    required this.nombre,
    required this.correo,
    required this.edad,
    required this.grupoEtario,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['id_paciente'],
      identificacion: json['identificacion'],
      nombre: json['nombre'],
      correo: json['correo'],
      edad: json['edad'],
      grupoEtario: json['grupo_etario'],
    );
  }
}
