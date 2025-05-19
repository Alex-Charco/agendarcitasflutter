import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/user_initials_avatar.dart';
import '../widgets/banner_widget.dart';
import '../widgets/card_feature_widget.dart';
import '../widgets/footer_widget.dart';

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
      backgroundColor: const Color.fromARGB(255, 243, 244, 246),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 🟢 Banner principal
                  BannerWidget(
                    title: 'Bienvenido a MiliSalud 17',
                    description: 'Tu salud es nuestra prioridad',
                    imageUrl: 'assets/images/hospital-banner.jpg',
                    buttons: [
                      BannerButton(
                          text: 'Agendar cita', link: '/registrar_cita'),
                      BannerButton(
                          text: 'Consuktar cita',
                          link: '/consultar_cita',
                          variant: 'secondary'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🟢 Cards de características
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: List.generate(2, (index) {
                            final data = [
                              {
                                'icon': const Icon(Icons.calendar_month_sharp,
                                    size: 40,
                                    color: Color.fromARGB(255, 13, 71, 161)),
                                'title': 'Agendar Citas',
                                'desc':
                                    'Reserva citas de forma fácil. Seleccione una fecha, hora, especialidad y médico para su consulta.',
                              },
                              {
                                'icon': const Icon(Icons.search_sharp,
                                    size: 40, color: Colors.green),
                                'title': 'Consultar Citas',
                                'desc':
                                    'Consulta el historial de tus citas médicas y accede a los detalles de cada una en cualquier momento.',
                              },
                            ];

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                final screenWidth =
                                    MediaQuery.of(context).size.width;
                                double cardWidth;

                                if (screenWidth >= 900) {
                                  cardWidth =
                                      (screenWidth - 64) / 3; // 3 columnas
                                } else if (screenWidth >= 600) {
                                  cardWidth =
                                      (screenWidth - 48) / 2; // 2 columnas
                                } else {
                                  cardWidth = screenWidth - 32; // 1 columna
                                }

                                return SizedBox(
                                  width: cardWidth,
                                  child: CardFeature(
                                    icon: data[index]['icon'] as Icon,
                                    title: data[index]['title'] as String,
                                    description: data[index]['desc'] as String,
                                  ),
                                );
                              },
                            );
                          }),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // 🟢 Footer fijo en la parte inferior si hay espacio
          const Footer(),
        ],
      ),
    );
  }
}
