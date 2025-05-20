import 'package:agendarcitasflutter/widgets/custom_alert.dart';
import 'package:agendarcitasflutter/utils/validators.dart';
import 'package:agendarcitasflutter/views/login_view.dart';
import 'package:agendarcitasflutter/services/auth_service.dart';
import 'package:agendarcitasflutter/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class ResetPasswordView extends StatefulWidget {
  final http.Client? httpClient;

  const ResetPasswordView({super.key, this.httpClient});

  @override
  ResetPasswordViewState createState() => ResetPasswordViewState();
}

class ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final String _message = "";
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(client: widget.httpClient);
  }

  Future<void> _requestPasswordReset() async {
    final urlReset = dotenv.env['API_URL_RESET'];
    if (urlReset == null) return;

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showErrorDialog(
          context, "Campo vacío", "Por favor ingresa un correo electrónico.");
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

    try {
      final response = await _authService.resetPassword(
        email: email,
        urlReset: urlReset,
      );

      final message = response['message'] ??
          "Si el correo está registrado, recibirás un enlace.";

      showSuccessDialog(
        // ignore: use_build_context_synchronously
        context,
        "Solicitud enviada",
        message,
        onConfirm: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        },
      );
    } catch (e) {
      showErrorDialog(
        // ignore: use_build_context_synchronously
        context,
        "Error",
        "No se pudo completar la solicitud. Verifica tu conexión e intenta nuevamente.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Stack(
                  children: [
                    // Fondo con imagen SVG
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/images/background.svg',
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Overlay de color (opcional)
                    Positioned.fill(
                      child: Container(
                        color: const Color.fromRGBO(0, 0, 0, 0.05),
                      ),
                    ),

                    Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/images/reset.svg',
                              height: 160,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFB2DBF7),
                                    Color(0xFFF5F7FC),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 32),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Recuperar Contraseña',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF004AAD),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Correo electrónico',
                                        prefixIcon:
                                            const Icon(Icons.email_outlined),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: 150,
                                      child: ElevatedButton(
                                        key: const Key('send_reset_button'),
                                        onPressed: _requestPasswordReset,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              6, 41, 165, 1),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: const Text(
                                          'Enviar',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_message.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        _message,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
