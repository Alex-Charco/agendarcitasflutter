import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static late SharedPreferences _prefs;

  // Inicialización
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Guardar token
  static Future<void> setToken(String token) async {
    await _prefs.setString('token', token);
  }

  // Obtener token (modificado para ser async)
  static Future<String?> getToken() async {
    return _prefs.getString('token');
  }

  // Guardar usuario
  static Future<void> setUser(Map<String, dynamic> user) async {
    await _prefs.setString('user', jsonEncode(user));
  }

  // Obtener usuario (modificado para ser async)
  static Future<Map<String, dynamic>?> getUser() async {
    final s = _prefs.getString('user');
    return s == null ? null : jsonDecode(s);
  }
}
