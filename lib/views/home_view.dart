import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/user_initials_avatar.dart';
import '../widgets/banner_widget.dart'; // ✅ Importa el Banner

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? firstName;
  String? lastName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      setState(() {
        firstName = userMap['primer_nombre'] ?? '';
        lastName = userMap['primer_apellido'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 252, 253),
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'MiliSalud 17',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: UserInitialsAvatar(
              firstName: firstName,
              lastName: lastName,
            ),
          ),
        ],
      ),

      // ✅ Nuevo contenido del body
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerWidget(
              title: 'Bienvenido a MiliSalud 17',
              description: 'Tu salud es nuestra prioridad',
              imageUrl: 'assets/images/hospital-banner.jpg',
              buttons: [
                BannerButton(text: 'Agendar cita', link: '/registrar_cita'),
                BannerButton(
                    text: 'Ver cita',
                    link: '/consultar_cita',
                    variant: 'secondary'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido a MiliSalud 17',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
