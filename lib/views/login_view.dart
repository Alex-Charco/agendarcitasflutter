import 'package:flutter/material.dart';
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final usuario = _usuarioController.text.trim();
    final password = _passwordController.text.trim();

    if (usuario.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Por favor, ingrese usuario y contraseña";
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nombre_usuario': usuario,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setInt(
            'rol', data['user']['rol']['id_rol']); // Guardar el rol

        // Validar el rol antes de redirigir
        if (data['user']['rol']['id_rol'] == 1) {
          Future.delayed(Duration.zero, () {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          Future.delayed(Duration.zero, () {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/dashboard');
          });
        }
      } else {
        setState(() => _errorMessage = data['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error de conexión');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: SvgPicture.asset(
                "assets/images/background.svg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0x4D0038FF), width: 4),
                  ),
                  elevation: 5,
                  shadowColor: const Color(0x800038FF),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 210,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _usuarioController,
                                decoration: const InputDecoration(
                                  labelText: 'Usuario',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.perm_identity),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Ingrese su usuario' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() =>
                                          _passwordVisible = !_passwordVisible);
                                    },
                                  ),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Ingrese su contraseña' : null,
                              ),
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 10),
                                Text(_errorMessage!,
                                    style: const TextStyle(color: Colors.red)),
                              ],
                              const SizedBox(height: 20),
                              _isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : Center(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width / 3,
                                        child: ElevatedButton(
                                          onPressed: _login,
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(const Color(0xFF004AAD)),
                                            minimumSize: WidgetStateProperty.all(
                                                const Size(double.infinity, 48)),
                                            padding: WidgetStateProperty.all(
                                                const EdgeInsets.symmetric(vertical: 16)),
                                            shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            )),
                                          ),
                                          child: const Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/reset');
                                  },
                                  child: const Text(
                                    '¿Recuperar Contraseña?',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.blue, width: 2),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Sistema de Gestión Hospitalaria',
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
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