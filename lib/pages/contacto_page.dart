import 'package:flutter/material.dart';
import '../widgets/footer_widget.dart';

class ContactoPage extends StatelessWidget {
  const ContactoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 244, 246),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 237, 241, 245),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Contáctanos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _glassCard(
                children: const [
                  Text(
                    'Hospital de Brigada de Selva No.17 “Pastaza”',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.indigo),
                    title: Text('Celular'),
                    subtitle: Text('099 134 6301'),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.indigo),
                    title: Text('Correo electrónico'),
                    subtitle: Text('contacto@hospitalcentral.com'),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.redAccent),
                    title: Text('Dirección'),
                    subtitle: Text('Av. Ceslao Marín, Puyo'),
                  ),
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

  static Widget _glassCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withAlpha((0.5 * 255).toInt()),
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
