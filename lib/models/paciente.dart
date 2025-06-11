class Paciente {
  final String identificacion;
  final String nombre;

  Paciente({
    required this.identificacion,
    required this.nombre,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      identificacion: json['identificacion'],
      nombre: json['nombre'],
    );
  }
}
