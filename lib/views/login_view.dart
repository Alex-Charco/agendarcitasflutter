import 'package:agendarcitasflutter/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _idController = TextEditingController();
  final LoginController _controller = LoginController();
  String? _errorMessage;

  void _onSubmit() {
  final idNumber = _idController.text.trim();
  final error = _controller.validateId(idNumber);

  if (mounted) {
      setState(() {
        _errorMessage = error;
      });
    }

  if (error == null) {
    final isLoggedIn = _controller.login(idNumber);
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    } else {
      setState(() {
        _errorMessage = 'El número de cédula ingresado es incorrecto.';
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withOpacity(0.05), // ignore: deprecated_member_use
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.white, // Simula una sombra interna
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Ingrese su número de cédula',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Número de cédula',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.perm_identity),
                    errorText: _errorMessage,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Ingresar'),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
