// Funciona bien y redirige... v2
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agendarcitasflutter/views/home_view.dart'; // Asegúrate de que la ruta sea la correcta.

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

  print('Usuario: $usuario');
  print('Password: $password');

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
    print('Respuesta API: $data');

    if (response.statusCode == 200 && data['token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setInt('rol', data['user']['rol']['id_rol']); // Guardar el rol

      // Validar el rol antes de redirigir
      if (data['user']['rol']['id_rol'] == 1) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        });
      }
    } else {
      setState(() => _errorMessage = data['message'] ?? 'Error desconocido');
    }
  } catch (e) {
    print('Error de conexión: $e');
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
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const  BorderSide(color: Color(0x4D0038FF), width: 4),
                ),
                elevation: 10,
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
                                    setState(() => _passwordVisible = !_passwordVisible);
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
								: Center( // <-- Esto centra el botón horizontalmente
									child: SizedBox(
									  width: MediaQuery.of(context).size.width / 3, // Ajusta el ancho a un tercio de la pantalla
									  child: ElevatedButton(
										onPressed: _login,
										style: ButtonStyle(
										  backgroundColor: WidgetStateProperty.all(const Color(0xFF004AAD)), // Color de fondo
										  minimumSize: WidgetStateProperty.all(const Size(double.infinity, 48)), // Altura del botón
										  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)), // Ajusta el padding si es necesario
										  shape: WidgetStateProperty.all(RoundedRectangleBorder(
											borderRadius: BorderRadius.circular(5), // Bordes redondeados
										  )),
										),
										child: const Text(
										  'Iniciar Sesión',
										  style: TextStyle(
											color: Colors.white, // Color del texto
											fontSize: 16, // Tamaño del texto
										  ),
										),
									  ),
									),
								  ),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home');
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
                              //padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.blue, width: 2)),
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
        ],
      ),
    );
  }
}





// Funciona bien y redirige a home, pero falta valide que ingrese rol... v1
/*import 'package:flutter/material.dart';
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
  
  print('Usuario: $usuario');
print('Password: $password');


  if (usuario.isEmpty || password.isEmpty) {
    setState(() {
      _errorMessage = "Por favor, ingrese usuario y contraseña";
      _isLoading = false;
    });
    return;
  }

    try {
      /*final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
        'usuario': usuario,
        'password': password,
      }),
    );*/
	
	final response = await http.post(
  Uri.parse('http://localhost:5000/api/auth/login'),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  body: jsonEncode({
    'nombre_usuario': usuario,  // Asegúrate de que la clave es la correcta según la API
    'password': password,
  }),
);


      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
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
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const  BorderSide(color: Color(0x4D0038FF), width: 4),
                ),
                elevation: 10,
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
                                    setState(() => _passwordVisible = !_passwordVisible);
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
								: Center( // <-- Esto centra el botón horizontalmente
									child: SizedBox(
									  width: MediaQuery.of(context).size.width / 3, // Ajusta el ancho a un tercio de la pantalla
									  child: ElevatedButton(
										onPressed: _login,
										style: ButtonStyle(
										  backgroundColor: WidgetStateProperty.all(const Color(0xFF004AAD)), // Color de fondo
										  minimumSize: WidgetStateProperty.all(const Size(double.infinity, 48)), // Altura del botón
										  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)), // Ajusta el padding si es necesario
										  shape: WidgetStateProperty.all(RoundedRectangleBorder(
											borderRadius: BorderRadius.circular(5), // Bordes redondeados
										  )),
										),
										child: const Text(
										  'Iniciar Sesión',
										  style: TextStyle(
											color: Colors.white, // Color del texto
											fontSize: 16, // Tamaño del texto
										  ),
										),
									  ),
									),
								  ),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home');
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
                              //padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.blue, width: 2)),
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
        ],
      ),
    );
  }
}
*/









/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': _usuarioController.text,
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        Navigator.pushReplacementNamed(context, '/home');
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
            child: SvgPicture.asset(
              "assets/images/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // Capa de opacidad
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0x4D0038FF), width: 4),
                ),
                elevation: 10,
                shadowColor: Color(0x800038FF),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity, // Hace que la imagen use todo el ancho
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 210, // Aumentado para mejor visibilidad
                          fit: BoxFit.fitWidth,  // Ajuste para ocupar todo el ancho sin distorsión
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Usuario
                            Row(
                              children: [
                                // Etiqueta Usuario alineada a la izquierda
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 100, // Ancho fijo para la etiqueta
                                    child: const Text(
                                      'Usuario:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Campo de Usuario
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),  // Ajusta el padding derecho según sea necesario
                                    child: TextFormField(
                                      controller: _usuarioController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Ingresar usuario',
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.perm_identity),
                                        errorText: _errorMessage,
                                        contentPadding: const EdgeInsets.only(right: 16.0),  // Agregar padding al contenido
                                      ),
                                      validator: (value) => value == null || value.isEmpty ? 'Ingrese su usuario' : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Contraseña
                            Row(
                              children: [
                                // Etiqueta Contraseña alineada a la izquierda
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 100, // Ancho fijo para la etiqueta
                                    child: const Text(
                                      'Contraseña:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Campo de Contraseña
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),  // Ajusta el padding derecho según sea necesario
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: !_passwordVisible,
                                      decoration: InputDecoration(
                                        labelText: 'Ingresar la contraseña',
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.perm_identity),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() => _passwordVisible = !_passwordVisible);
                                          },
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (_errorMessage != null) ...[
                              SizedBox(height: 10),
                              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                            ],

                            SizedBox(height: 20),

                            _isLoading
                                ? CircularProgressIndicator()
                                : Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,  // Ajusta el ancho a un tercio del ancho de la pantalla
                                      child: ElevatedButton(
                                        onPressed: _login,
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Color(0xFF004AAD)), // Color de fondo
                                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 48)),  // Altura del botón
                                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),  // Ajusta el padding si es necesario
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),  // Bordes redondeados
                                          )),
                                        ),
                                        child: Text(
                                          'Iniciar Sesión',
                                          style: TextStyle(
                                            color: Colors.white,  // Color del texto
                                            fontSize: 16,  // Tamaño del texto
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                            // Margen debajo del botón
                            SizedBox(height: 5),
							
							// Enlace Recuperar Contraseña
                            Center(
							  child: TextButton(
								onPressed: () {
								  // Lógica para navegar a la página de recuperación de contraseña
								  Navigator.pushNamed(context, '/reset-password');
								},
								child: Text(
								  '¿Recuperar Contraseña?',
								  style: TextStyle(
								  color: Colors.blue,
								  fontSize: 13,
								  ),
								),
							  ),
							),
							SizedBox(height: 10),

                            // Texto Sistema de gestión hospitalaria con borde superior
                            Container(
							  width: double.infinity, // Hace que la línea superior abarque todo el ancho
							  padding: EdgeInsets.symmetric(vertical: 10), // Espaciado uniforme arriba y abajo
							  decoration: BoxDecoration(
								border: Border(top: BorderSide(color: Colors.blue, width: 2)), // Línea superior
							  ),
							  alignment: Alignment.center, // Centra el texto dentro del contenedor
							  child: Text(
								'Sistema de Gestión Hospitalaria',
								style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
								textAlign: TextAlign.center, // Asegura alineación centrada en caso de varias líneas
							  ),
							),

                            
                          ],
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
*/




/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': _usuarioController.text,
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        Navigator.pushReplacementNamed(context, '/home');
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
            child: SvgPicture.asset(
              "assets/images/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // Capa de opacidad
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0x4D0038FF), width: 4),
                ),
                elevation: 10,
                shadowColor: Color(0x800038FF),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity, // Hace que la imagen use todo el ancho
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 250, // Aumentado para mejor visibilidad
                          fit: BoxFit.fitWidth,  // Ajuste para ocupar todo el ancho sin distorsión
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Usuario
                            Row(
                              children: [
                                // Etiqueta Usuario alineada a la izquierda
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 100, // Ancho fijo para la etiqueta
                                    child: const Text(
                                      'Usuario:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Campo de Usuario
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),  // Ajusta el padding derecho según sea necesario
                                    child: TextFormField(
                                      controller: _usuarioController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Ingresar usuario',
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.perm_identity),
                                        errorText: _errorMessage,
                                        contentPadding: const EdgeInsets.only(right: 16.0),  // Agregar padding al contenido
                                      ),
                                      validator: (value) => value == null || value.isEmpty ? 'Ingrese su usuario' : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Contraseña
                            Row(
                              children: [
                                // Etiqueta Contraseña alineada a la izquierda
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 100, // Ancho fijo para la etiqueta
                                    child: const Text(
                                      'Contraseña:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Campo de Contraseña
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),  // Ajusta el padding derecho según sea necesario
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: !_passwordVisible,
                                      decoration: InputDecoration(
                                        labelText: 'Ingresar la contraseña',
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.perm_identity),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() => _passwordVisible = !_passwordVisible);
                                          },
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (_errorMessage != null) ...[
                              SizedBox(height: 10),
                              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                            ],

                            SizedBox(height: 20),

                            _isLoading
                                ? CircularProgressIndicator()
                                : Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width / 3,  // Ajusta el ancho a un tercio del ancho de la pantalla
                                      child: ElevatedButton(
                                        onPressed: _login,
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Color(0xFF004AAD)), // Color de fondo
                                          minimumSize: MaterialStateProperty.all(Size(double.infinity, 48)),  // Altura del botón
                                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),  // Ajusta el padding si es necesario
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),  // Bordes redondeados
                                          )),
                                        ),
                                        child: Text(
                                          'Iniciar Sesión',
                                          style: TextStyle(
                                            color: Colors.white,  // Color del texto
                                            fontSize: 16,  // Tamaño del texto
                                          ),
                                        ),
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
            ),
          ),
        ],
      ),
    );
  }
}
*/









/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': _usuarioController.text,
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        Navigator.pushReplacementNamed(context, '/home');
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
            child: SvgPicture.asset(
              "assets/images/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // Capa de opacidad
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0x4D0038FF), width: 4),
                ),
                elevation: 10,
                shadowColor: Color(0x800038FF),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity, // Hace que la imagen use todo el ancho
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 250, // Aumentado para mejor visibilidad
                          fit: BoxFit.fitWidth,  // Ajuste para ocupar todo el ancho sin distorsión
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Usuario
                            Row(
                              children: [
                                // Etiqueta Usuario alineada a la izquierda
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 100, // Ancho fijo para la etiqueta
                                    child: const Text(
                                      'Usuario:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Campo de Usuario
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),  // Ajusta el padding derecho según sea necesario
                                    child: TextFormField(
                                      controller: _usuarioController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Ingresar usuario',
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.perm_identity),
                                        errorText: _errorMessage,
                                        contentPadding: const EdgeInsets.only(right: 16.0),  // Agregar padding al contenido
                                      ),
                                      validator: (value) => value == null || value.isEmpty ? 'Ingrese su usuario' : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Contraseña
                            Row(
                              children: [
                                // Etiqueta Contraseña alineada a la izquierda
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 100, // Ancho fijo para la etiqueta
                                    child: const Text(
                                      'Contraseña:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Campo de Contraseña
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),  // Ajusta el padding derecho según sea necesario
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: !_passwordVisible,
                                      decoration: InputDecoration(
                                        labelText: 'Ingresar la contraseña',
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.perm_identity),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() => _passwordVisible = !_passwordVisible);
                                          },
                                        ),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (_errorMessage != null) ...[
                              SizedBox(height: 10),
                              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                            ],

                            SizedBox(height: 20),

                            _isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _login,
                                    child: Text('Iniciar Sesión'),
                                  ),
                          ],
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
*/






/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': _usuarioController.text,
          'password': _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        Navigator.pushReplacementNamed(context, '/home');
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
            child: SvgPicture.asset(
              "assets/images/background.svg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // Capa de opacidad
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0x4D0038FF), width: 4),
                ),
                elevation: 10,
                shadowColor: Color(0x800038FF),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity, // Hace que la imagen use todo el ancho
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 250, // Aumentado para mejor visibilidad
                          fit: BoxFit.fitWidth,  // Ajuste para ocupar todo el ancho sin distorsión
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Usuario
                            Row(
                              children: [
                                // Etiqueta Usuario alineada a la izquierda
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 100, // Ancho fijo para la etiqueta
                                    child: const Text(
                                      'Usuario:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Campo de Usuario
                                Expanded(
                                  Padding(
								  padding: const EdgeInsets.only(right: 16.0),  // Ajusta el padding derecho según sea necesario
								  child: TextFormField(
                                    controller: _usuarioController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: 'Ingresar usuario',
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.perm_identity),
                                      errorText: _errorMessage,
									  contentPadding: const EdgeInsets.only(right: 16.0),  // Agregar padding al contenido
                                    ),
                                    validator: (value) => value == null || value.isEmpty ? 'Ingrese su usuario' : null,
                                  ),
								  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Contraseña
                            Row(
                              children: [
                                // Etiqueta Contraseña alineada a la izquierda
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 100, // Ancho fijo para la etiqueta
                                    child: const Text(
                                      'Contraseña:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Campo de Contraseña
                                Expanded(
                                  Padding(
								  padding: const EdgeInsets.only(right: 16.0),  // Ajusta el padding derecho según sea necesario
								  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_passwordVisible,
                                    decoration: InputDecoration(
                                      labelText: 'Ingresar la contraseña',
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.perm_identity),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() => _passwordVisible = !_passwordVisible);
                                        },
                                      ),
                                    ),
                                    validator: (value) => value!.isEmpty ? 'Ingrese su contraseña' : null,
                                  ),
								  
								  ),
                                ),
                              ],
                            ),

                            if (_errorMessage != null) ...[
                              SizedBox(height: 10),
                              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                            ],

                            SizedBox(height: 20),

                            _isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _login,
                                    child: Text('Iniciar Sesión'),
                                  ),
                          ],
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
*/




// version 1
/*import 'package:agendarcitasflutter/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:agendarcitasflutter/views/home_view.dart';

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
        _errorMessage = 'El usuario o contraseña está incorrecto.';
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
                  'Usuario',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Ingresar usuario',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.perm_identity),
                    errorText: _errorMessage,
                  ),
                ),
				const Text(
                  'Contraseña',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Ingresar la contraseña',
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
*/