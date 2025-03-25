import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  ResetPasswordViewState createState() => ResetPasswordViewState();
}

class ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  String _message = "";

  Future<void> _requestPasswordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _message = "Por favor ingresa un correo electrónico";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:5000/auth/request-password-reset'), // Cambia la URL de la API según corresponda
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _message = data['message'] ??
              "Si el correo está registrado, recibirás un enlace.";
        });
      } else {
        setState(() {
          _message = data['message'] ?? "Ocurrió un error, intenta nuevamente.";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error de conexión. Intenta nuevamente.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Recuperar Contraseña',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    // Centra el botón horizontalmente
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width /
                          3, // Ajusta el ancho a un tercio de la pantalla
                      child: ElevatedButton(
                        onPressed: _requestPasswordReset,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              const Color(0xFF004AAD)), // Color de fondo
                          minimumSize: WidgetStateProperty.all(const Size(
                              double.infinity, 48)), // Altura del botón
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16)), // Padding en ambos ejes
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Bordes redondeados
                          )),
                        ),
                        child: const Text(
                          'Enviar enlace de recuperación',
                          style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontSize: 16, // Tamaño del texto
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_message.isNotEmpty)
                    Text(
                      _message,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
