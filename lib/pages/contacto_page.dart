import 'package:agendarcitasflutter/widgets/glass_card_widget.dart';
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              GlassCard(
                children: [
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
                    subtitle: Text('brigadaselva17hostipal@ejercito.mil.ec'),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.redAccent),
                    title: Text('Dirección'),
                    subtitle: Text('Av. General Eloy Alfaro y Calle Ceslao Marin, cerca de Iglesia Católica Jesús del Gran Poder - Pindo (El Dorado).'),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
