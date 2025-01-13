import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamiento de citas médicas'),
      ),
      body: const Center(
        child: Text(
          'Bienvenido a la página principal',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
