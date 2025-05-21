class Validators {
  static String? validateUser(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese su usuario';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingrese su contraseña';
    } else if (value.length < 10) {
      return 'La contraseña debe tener al menos 10 caracteres';
    }
    return null;
  }

  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }
}
