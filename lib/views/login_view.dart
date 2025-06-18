import 'dart:async';
import 'package:agendarcitasflutter/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agendarcitasflutter/utils/validators.dart';

class LoginView extends StatefulWidget {
  final http.Client? httpClient;
  final void Function(BuildContext context, int idRol)? onLoginSuccess;
  const LoginView({
    super.key,
    this.httpClient,
    this.onLoginSuccess,
  });

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  String? _errorMessage;
  bool _loginSuccess = false;
  String? errorMessage;

  DateTime? _lockoutEndTime;
  late LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(
      context: context,
      client: widget.httpClient ?? http.Client(),
      onLoginSuccess: widget.onLoginSuccess,
    );
    _controller.loadLockoutState();
    checkExpiredSession();
  }

  Future<void> checkExpiredSession() async {
    final prefs = await SharedPreferences.getInstance();
    final expired = prefs.getBool('expiredSession') ?? false;

    if (expired) {
      setState(() {
        errorMessage =
            'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.';
      });
      await prefs.remove('expiredSession');
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    if (_lockoutEndTime != null && DateTime.now().isBefore(_lockoutEndTime!)) {
      setState(() {
        _errorMessage =
            'Has superado el número máximo de intentos. Tu cuenta está bloqueada hasta las ${_lockoutEndTime!.hour.toString().padLeft(2, '0')}:${_lockoutEndTime!.minute.toString().padLeft(2, '0')}';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _loginSuccess = false;
    });

    final url = dotenv.env['API_URL'];
    if (url == null) return;

    await _controller.login(
      url: url,
      username: _usuarioController.text.trim(),
      password: _passwordController.text.trim(),
      onLoginSuccessSet: (bool success) {
        setState(() {
          _loginSuccess = success;
          _errorMessage = null;
        });

        Timer(const Duration(seconds: 1), () {
          if (!context.mounted) return;

          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!(
                context, 1); // Pasa el idRol real aquí si lo tienes
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      },
      onError: (String? message) {
        setState(() => _errorMessage = message);
      },
    );
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
                    Positioned.fill(
                      child: SvgPicture.asset(
                        "assets/images/background.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: const Color.fromRGBO(0, 0, 0, 0.05),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 90),
						child: Padding(
							padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Centrado vertical
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // Centrado horizontal
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 420),
                              child: Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                    color: Color(0x4D0038FF),
                                    width: 4,
                                  ),
                                ),
                                shadowColor: const Color(0x800038FF),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        height: 120,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFB2DBF7),
                                            Color(0xFFF5F7FC)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 24),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: _usuarioController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Ingresar el usuario *',
                                                labelStyle: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 14,
                                                ),
                                                prefixIcon: Icon(Icons.person,
                                                    color: Colors.grey[500]),
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade50),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF0629A5),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              validator: Validators.validateUser,
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              key: const Key('passwordField'),
                                              controller: _passwordController,
                                              obscureText: !_passwordVisible,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'Ingresar la contraseña *',
                                                labelStyle: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 14,
                                                ),
                                                prefixIcon: Icon(Icons.lock,
                                                    color: Colors.grey[500]),
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade50),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF0629A5),
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    _passwordVisible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.grey[600],
                                                  ),
                                                  onPressed: () {
                                                    setState(() =>
                                                        _passwordVisible =
                                                            !_passwordVisible);
                                                  },
                                                ),
                                              ),
                                              validator: Validators.validatePassword,
                                            ),
                                            if (_errorMessage != null) ...[
                                              const SizedBox(height: 12),
                                              Text(_errorMessage!,
                                                  style: const TextStyle(
                                                      color: Colors.red)),
                                            ],
                                            if (errorMessage != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 12.0),
                                                child: Text(
                                                  errorMessage!,
                                                  key: const Key(
                                                      'expiredSessionMessage'),
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            if (_loginSuccess) ...[
                                              const SizedBox(height: 12),
                                              const Text(
                                                "Inicio de sesión exitoso. Redirigiendo...",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                            const SizedBox(height: 24),
                                            Center(
                                              child: SizedBox(
                                                width:
                                                    150, // Ajusta este valor al tamaño que desees
                                                child: ElevatedButton(
                                                  onPressed: _login,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            6, 41, 165, 1),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 18),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Ingresar',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Flexible(
                                                      child: Text(
                                                        '¿Olvidaste tu contraseña?: ',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFF374151),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/reset');
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          minimumSize:
                                                              const Size(0, 0),
                                                          tapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                        ),
                                                        child: const Text(
                                                          'Recuperar contraseña',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromRGBO(
                                                                    6,
                                                                    41,
                                                                    165,
                                                                    1),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Divider(),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Sistema de Gestión Hospitalaria",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    6, 41, 165, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
          },
        ),
      ),
    );
  }
}
