import 'dart:convert';
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
      final String primerNombre = userMap['primer_nombre'] ?? '';
      final String segundoNombre = userMap['segundo_nombre'] ?? '';
      final String primerApellido = userMap['primer_apellido'] ?? '';
      final String segundoApellido = userMap['segundo_apellido'] ?? '';

      final String nombreCompleto = '$primerNombre $segundoNombre $primerApellido $segundoApellido'.trim();

      setState(() {
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
            accountName: Text(nombrePaciente ?? 'Paciente28'),
            accountEmail: Text(nombreRol ?? 'Paciente'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
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
