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

  Future<void> _login() async {
    final url = dotenv.env['API_URL'];
    if (url == null) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
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

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context,
            data['user']['rol']['id_rol'] == 1 ? '/home' : '/dashboard');
      } else {
        setState(() => _errorMessage = data['message'] ?? 'Error desconocido');
      }
    } catch (_) {
      setState(() => _errorMessage = 'Error de conexión');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/images/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          // Capa negra translúcida
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.05),
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
                      color: Color(0x4D0038FF), // Azul translúcido
                      width: 4,
                    ),
                  ),
                  shadowColor: const Color(0x800038FF),
                  // Eliminamos el padding interior aquí y lo movemos solo a la parte del formulario
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Imagen con fondo blanco ocupando todo el ancho
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
                      // Formulario con padding interno
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
                                    color: Colors.grey[600],
                                    fontSize: 14, // Tamaño del label
                                  ),
                                  prefixIcon: Icon(Icons.person,
                                      color: Colors.grey[500]),
                                  filled: true,
                                  fillColor:
                                      Colors.grey[100], // Fondo gris claro
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(6, 41, 165, 1),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? 'Ingrese su usuario'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Ingresar la contraseña *',
                                  labelStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14, // Tamaño del label
                                  ),
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.grey[500]),
                                  filled: true,
                                  fillColor:
                                      Colors.grey[100], // Fondo gris claro
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
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
                                      color: Colors
                                          .grey[600], // Cambia el color aquí
                                    ),
                                    onPressed: () {
                                      setState(() =>
                                          _passwordVisible = !_passwordVisible);
                                    },
                                  ),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? 'Ingrese su contraseña'
                                    : null,
                              ),
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Text(_errorMessage!,
                                    style: const TextStyle(color: Colors.red)),
                              ],
                              const SizedBox(height: 24),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : Center(
                                      child: SizedBox(
                                        width: 150, // Ancho reducido
                                        child: ElevatedButton(
                                          onPressed: _login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    6, 41, 165, 1),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18), // Más alto
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                              const SizedBox(height: 12),
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
                                            color: Color.fromRGBO(6, 41, 165, 1),
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
