import 'package:agendarcitasflutter/widgets/glass_card_widget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/footer_widget.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Map<String, dynamic>? userData;
  String nombreCompleto = '';
  String iniciales = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      final String primerNombre = userMap['primer_nombre'] ?? '';
      final String segundoNombre = userMap['segundo_nombre'] ?? '';
      final String primerApellido = userMap['primer_apellido'] ?? '';
      final String segundoApellido = userMap['segundo_apellido'] ?? '';
      setState(() {
        userData = userMap;
        nombreCompleto =
            '$primerNombre $segundoNombre $primerApellido $segundoApellido'
                .trim();
        iniciales = _getInitials(primerNombre, primerApellido);
      });
    }
  }

  String _getInitials(String primerNombre, String primerApellido) {
    String primeraInicial = primerNombre.isNotEmpty ? primerNombre[0] : '';
    String segundaInicial = primerApellido.isNotEmpty ? primerApellido[0] : '';
    return (primeraInicial + segundaInicial).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 244, 246),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 241, 245),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 0, 74, 173),
                child: Text(
                  iniciales,
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                nombreCompleto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 30),
              GlassCard(
                children: [
                  _buildInfoRow('Usuario', userData!['nombre_usuario'],
                      icon: Icons.person, iconColor: Colors.indigo),
                  const Divider(),
                  _buildInfoRow('Identificación', userData!['identificacion'],
                      icon: Icons.badge, iconColor: Colors.teal),
                  const Divider(),
                  _buildInfoRow('Rol', userData!['rol']?['nombre_rol'],
                      icon: Icons.verified_user,
                      iconColor: Colors.deepPurple),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }

  Widget _buildInfoRow(String title, String? value,
      {required IconData icon, required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
