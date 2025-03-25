import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamiento de citas médicas'),
      ),
      body: SafeArea( // Se agrega SafeArea para evitar problemas en dispositivos con notch
        child: Center(
          child: Semantics( // Se agrega Semantics para mejorar accesibilidad
            label: 'Mensaje de bienvenida',
            child: const Text(
              'Bienvenido a la página principal',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
