import 'package:agendarcitasflutter/widgets/custom_alert.dart';
import 'package:agendarcitasflutter/utils/validators.dart';
import 'package:agendarcitasflutter/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  ResetPasswordViewState createState() => ResetPasswordViewState();
}

class ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final String _message = "";

  Future<void> _requestPasswordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      CustomAlert.showErrorDialog(
        context: context,
        title: "Campo vacío",
        message: "Por favor ingresa un correo electrónico.",
      );
      return;
    }
	
	if (!Validators.isValidEmail(email)) {
      CustomAlert.showErrorDialog(
        context: context,
        title: "Correo inválido",
        message: "Por favor ingresa un correo electrónico válido.",
      );
      return;
    }

    // v4: Solicitud para reiniciar contraseña
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/auth/request-password-reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);
      final message =
          data['message'] ?? "Si el correo está registrado, recibirás un enlace.";

      // Mostrar mensaje de confirmación con CustomAlert
      CustomAlert.showSuccessDialog(
        // ignore: use_build_context_synchronously
        context: context,
        title: "Solicitud enviada",
        message: message,
		onConfirm: () {
          // Redirigir al login cuando el usuario haga clic en OK
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        },
      );
    } catch (e) {
      // Mostrar mensaje de error con CustomAlert
      CustomAlert.showErrorDialog(
        // ignore: use_build_context_synchronously
        context: context,
        title: "Error",
        message:
            "No se pudo completar la solicitud. Verifica tu conexión e intenta nuevamente.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen SVG centrada fuera de la Card
            SvgPicture.asset(
              'assets/images/reset.svg',
              height: 170,
            ),
            const SizedBox(height: 20),

            // Card con el formulario
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
				  side: const BorderSide(color: Color(0x800038FF), width: 4),
				  ),
				shadowColor: const Color(0x800038FF),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Recuperar Contraseña',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _requestPasswordReset,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xFF004AAD)),
                          minimumSize: WidgetStateProperty.all(Size(
                              MediaQuery.of(context).size.width / 3,
                              48)), // Ancho dinámico
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 16)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                        ),
                        child: const Text(
                          'Enviar',
                          style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontSize: 16, // Tamaño del texto
                          ),
                        ),
                      ),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}