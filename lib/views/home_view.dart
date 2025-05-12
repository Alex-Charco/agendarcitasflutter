import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';import '../pages/consulta_cita_paciente_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamiento de citas médicas'),
      ),
      drawer: const CustomDrawer(), // ✅ Aquí llamas tu Drawer separado
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Mensaje de bienvenida',
                child: const Text(
                  'Bienvenido a la página principal', 
                  key: Key('welcome-text'),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsultaCitaPacientePage(),
                    ),
                  );
                },
                child: const Text('Consultar Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}