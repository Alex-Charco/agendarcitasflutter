import 'dart:convert';
import 'package:agendarcitasflutter/pages/consulta_cita_paciente_page.dart';
import 'package:agendarcitasflutter/widgets/user_initials_avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/perfil_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? nombrePaciente;
  String? nombreRol;
  String? primerNombre;       // ✅ Mover aquí
  String? primerApellido;     // ✅ Mover aquí

  @override
  void initState() {
    super.initState();
    _loadNombrePaciente();
  }

  Future<void> _loadNombrePaciente() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      final String primerNombreLocal = userMap['primer_nombre'] ?? '';
      final String segundoNombre = userMap['segundo_nombre'] ?? '';
      final String primerApellidoLocal = userMap['primer_apellido'] ?? '';
      final String segundoApellido = userMap['segundo_apellido'] ?? '';

      final String nombreCompleto = '$primerNombreLocal $segundoNombre $primerApellidoLocal $segundoApellido'.trim();

      setState(() {
        primerNombre = primerNombreLocal;
        primerApellido = primerApellidoLocal;
        nombrePaciente = nombreCompleto;
        nombreRol = userMap['rol']?['nombre_rol'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(nombrePaciente ?? 'Paciente'),
            accountEmail: Text(nombreRol ?? 'Paciente'),
            currentAccountPicture: UserInitialsAvatar(
              firstName: primerNombre ?? '',
              lastName: primerApellido ?? '',
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 74, 173),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contacto'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConsultaCitaPacientePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Consultar Cita'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConsultaCitaPacientePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Crear Cita'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConsultaCitaPacientePage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              // ignore: use_build_context_synchronously
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
