import '../models/user_model.dart';

class LoginController {
  final String _defaultIdNumber = "1234567890";

  // Método para validar el número de cédula
  String? validateId(String idNumber) {
    if (idNumber.isEmpty) {
      return 'Por favor, ingrese su número de cédula.';
    }

    try {
      final user = UserModel(idNumber);
      if (!user.isValidId()) {
        return 'El número de cédula debe tener al menos 10 dígitos.';
      }
    } catch (e) {
      return 'Hubo un error al procesar el número de cédula.';
    }

    return null; 
  }

  // Método para iniciar sesión
  bool login(String idNumber) {
    return idNumber == _defaultIdNumber; 
  }
}
