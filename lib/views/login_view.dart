import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _loginSuccess = false;
  int _failedAttempts = 0;

  final int _maxFailedAttempts = 3;
  final int _lockoutMinutes = 15;

  DateTime? _lockoutEndTime;

  @override
  void initState() {
    super.initState();
    _loadLockoutState();
  }

  Future<void> _loadLockoutState() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeStr = prefs.getString('lockoutEndTime');
    if (endTimeStr != null) {
      final lockoutEnd = DateTime.tryParse(endTimeStr);
      if (lockoutEnd != null && lockoutEnd.isAfter(DateTime.now())) {
        setState(() => _lockoutEndTime = lockoutEnd);
      } else {
        await prefs.remove('lockoutEndTime');
      }
    }
  }

  Future<void> _setLockout() async {
    final prefs = await SharedPreferences.getInstance();
    final lockoutEnd = DateTime.now().add(Duration(minutes: _lockoutMinutes));
    await prefs.setString('lockoutEndTime', lockoutEnd.toIso8601String());
    setState(() {
      _lockoutEndTime = lockoutEnd;
      _errorMessage =
          'Has superado el número máximo de intentos. Tu cuenta se ha bloqueado por 15 minutos.';
    });
  }

  Future<void> _login() async {
    final url = dotenv.env['API_URL'];
    if (url == null) return;
    if (!_formKey.currentState!.validate()) return;

    if (_lockoutEndTime != null && DateTime.now().isBefore(_lockoutEndTime!)) {
      setState(() {
        _errorMessage =
            'Has superado el número máximo de intentos. Tu cuenta está bloqueada hasta las ${_lockoutEndTime!.hour.toString().padLeft(2, '0')}:${_lockoutEndTime!.minute.toString().padLeft(2, '0')}.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _loginSuccess = false;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre_usuario': _usuarioController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setInt('rol', data['user']['rol']['id_rol']);
        await prefs.setString('identificacion', data['user']['identificacion']);
        await prefs.setString('user', jsonEncode(data['user']));
        await prefs.remove('lockoutEndTime');

        setState(() {
          _loginSuccess = true;
          _failedAttempts = 0;
          _lockoutEndTime = null;
        });

        Timer(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context,
              data['user']['rol']['id_rol'] == 1 ? '/home' : '/dashboard');
        });
      } else {
        setState(() {
          _failedAttempts++;
          if (_failedAttempts >= _maxFailedAttempts) {
            _setLockout();
          } else {
            _errorMessage = data['message'] ?? 'Error desconocido';
          }
        });
      }
    } catch (_) {
      setState(() {
        _failedAttempts++;
        if (_failedAttempts >= _maxFailedAttempts) {
          _setLockout();
        } else {
          _errorMessage = 'Error de conexión';
        }
      });
    }

    setState(() => _isLoading = false);
  }

  String? _validateUser(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese su usuario';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese su contraseña';
    } else if (value.length < 10) {
      return 'La contraseña debe tener al menos 10 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Center(
            child: SingleChildScrollView(
              child: Container(
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                            colors: [Color(0xFFB2DBF7), Color(0xFFF5F7FC)],
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
                                  labelText: 'Ingresar el usuario *',
                                  labelStyle: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(Icons.person,
                                      color: Colors.grey[500]),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 252, 251, 251),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(6, 41, 165, 1),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: _validateUser,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Ingresar la contraseña *',
                                  labelStyle: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.grey[500]),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 252, 251, 251),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(6, 41, 165, 1),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      setState(() => _passwordVisible = !_passwordVisible);
                                    },
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Text(_errorMessage!,
                                    style: const TextStyle(color: Colors.red)),
                              ],
                              if (_loginSuccess) ...[
                                const SizedBox(height: 12),
                                const Text(
                                  "Inicio de sesión exitoso. Redirigiendo...",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                              const SizedBox(height: 24),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : Center(
                                      child: SizedBox(
                                        width: 150,
                                        child: ElevatedButton(
                                          onPressed: _login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(6, 41, 165, 1),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          child: const Text(
                                            'Ingresar',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 16),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '¿Olvidaste tu contraseña?: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/reset');
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text(
                                          'Recuperar contraseña',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Color.fromRGBO(6, 41, 165, 1),
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
                                  color: Color.fromRGBO(6, 41, 165, 1),
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
            ),
          ),
        ],
      ),
    );
  }
}
