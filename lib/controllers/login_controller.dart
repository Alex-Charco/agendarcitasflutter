import '../models/user_model.dart';

class LoginController {
  // Número de cédula predeterminado para iniciar sesión
  final String _defaultIdNumber = "1234567890";

  String? validateId(String idNumber) {
    final user = UserModel(idNumber);
    if (idNumber.isEmpty) {
      return 'Por favor, ingrese su número de cédula.';
    } else if (!user.isValidId()) {
      return 'El número de cédula debe tener al menos 10 dígitos.';
    }
    return null; 
  }

  bool login(String idNumber) {
    // Comprobar si el número ingresado coincide con el predeterminado
    if (idNumber == _defaultIdNumber) {
      return true; 
    }
    return false;
  }
}
