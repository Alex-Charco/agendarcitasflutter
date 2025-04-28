import 'package:flutter/material.dart';
import '../pages/consulta_cita_paciente_page.dart'; // Asegúrate de crear este archivo también

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamiento de citas médicas'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Mensaje de bienvenida',
                child: const Text(
                  'Bienvenido a la página principal',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  const ConsultaCitaPacientePage(),
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
