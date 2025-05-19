import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF90C0E8),
                Color.fromARGB(255, 151, 203, 246),
                Color(0xFFF5F7FC),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: CircleAvatar(
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
              ),
              const SizedBox(height: 20),
              Text(
                nombreCompleto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.indigo,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 30),
              _glassCard(
                children: [
                  _buildInfoRow(
                    'Usuario',
                    userData!['nombre_usuario'],
                    icon: Icons.person,
                    iconColor: Colors.indigo,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Identificación',
                    userData!['identificacion'],
                    icon: Icons.badge,
                    iconColor: Colors.teal,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Rol',
                    userData!['rol']?['nombre_rol'],
                    icon: Icons.verified_user,
                    iconColor: Colors.deepPurple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  Widget _glassCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.75),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.white70, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
