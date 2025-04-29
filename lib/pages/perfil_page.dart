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
        nombreCompleto = '$primerNombre $segundoNombre $primerApellido $segundoApellido'.trim();
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
      appBar: AppBar(
        title: const Text(
          'Perfil del Usuario',
          style: TextStyle(color: Colors.white), // Aquí cambias el color
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo, // Color más profesional
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo.shade100,
                child: Text(
                  iniciales,
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                nombreCompleto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      _buildInfoRow('Usuario', userData!['nombre_usuario']),
                      const Divider(),
                      _buildInfoRow('Identificación', userData!['identificacion']),
                      const Divider(),
                      _buildInfoRow('Rol', userData!['rol']?['nombre_rol']),
                      // Puedes agregar más campos aquí si quieres
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
