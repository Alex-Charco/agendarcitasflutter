import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agendarcitasflutter/services/auth_service.dart';

class LoginController {
  final BuildContext context;
  final http.Client client;
  final void Function(BuildContext context, int idRol)? onLoginSuccess;
  final int maxFailedAttempts = 3;
  final int lockoutMinutes = 15;

  int failedAttempts = 0;
  DateTime? lockoutEndTime;
  final AuthService authService;

  LoginController({
    required this.context,
    required this.client,
    this.onLoginSuccess,
  }) : authService = AuthService(client: client);

  /// Carga el estado de bloqueo desde SharedPreferences.
  Future<void> loadLockoutState() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeStr = prefs.getString('lockoutEndTime');
    if (endTimeStr != null) {
      final lockoutEnd = DateTime.tryParse(endTimeStr);
      if (lockoutEnd != null && lockoutEnd.isAfter(DateTime.now())) {
        lockoutEndTime = lockoutEnd;
      } else {
        await prefs.remove('lockoutEndTime');
      }
    }
  }

  /// Verifica si el usuario está bloqueado por múltiples intentos fallidos.
  bool isLockedOut(ValueSetter<String> onError) {
    if (lockoutEndTime != null && DateTime.now().isBefore(lockoutEndTime!)) {
      final message =
          'Has superado el número máximo de intentos. Tu cuenta está bloqueada hasta '
          '${lockoutEndTime!.hour.toString().padLeft(2, '0')}:${lockoutEndTime!.minute.toString().padLeft(2, '0')}.';
      onError(message);
      return true;
    }
    return false;
  }

  /// Lógica de login con validación de rol y manejo de errores.
  Future<void> login({
    required String url,
    required String username,
    required String password,
    required ValueSetter<bool> onLoginSuccessSet,
    required ValueSetter<String?> onError,
  }) async {
    try {
      final data = await authService.login(
        urlLogin: url,
        username: username,
        password: password,
      );

      if (data['token'] != null) {
        final idRol = data['user']['rol']['id_rol'];
        if (idRol == 1) {
          await _handleSuccessfulLogin(data, idRol, onLoginSuccessSet, onError);
        } else {
          _handleFailedLogin(
            onError,
            "Solo los pacientes pueden ingresar en esta aplicación.",
          );
        }
      } else {
        _handleFailedLogin(
          onError,
          data['message'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      _handleFailedLogin(onError, e.toString());
    }
  }

  Future<void> _handleSuccessfulLogin(
    dynamic data,
    int idRol,
    ValueSetter<bool> onLoginSuccessSet,
    ValueSetter<String?> onError,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['token']);
    await prefs.setInt('rol', idRol);
    await prefs.setString('identificacion', data['user']['identificacion']);
    await prefs.setString('user', jsonEncode(data['user']));
    await prefs.remove('lockoutEndTime');

    failedAttempts = 0;
    lockoutEndTime = null;

    onLoginSuccessSet(true);
    onError(null);

    Timer(const Duration(seconds: 1), () {
      if (!context.mounted) return;
      if (onLoginSuccess != null) {
        onLoginSuccess!(context, idRol);
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  void _handleFailedLogin(
    ValueSetter<String?> onError,
    String message,
  ) {
    _incrementAttempts(onError, message);
  }

  /// Maneja los intentos fallidos y aplica bloqueo si se supera el límite.
  void _incrementAttempts(ValueSetter<String?> onError, String message) async {
    failedAttempts++;
    if (failedAttempts >= maxFailedAttempts) {
      await _setLockout(onError);
    } else {
      onError(message);
    }
  }

  /// Establece el tiempo de bloqueo y lo guarda en SharedPreferences.
  Future<void> _setLockout(ValueSetter<String?> onError) async {
    final prefs = await SharedPreferences.getInstance();
    final lockoutEnd = DateTime.now().add(Duration(minutes: lockoutMinutes));
    await prefs.setString('lockoutEndTime', lockoutEnd.toIso8601String());
    lockoutEndTime = lockoutEnd;
    onError(
      'Has superado el número máximo de intentos. Tu cuenta se ha bloqueado por $lockoutMinutes minutos.',
    );
  }

  /// Método que puedes llamar desde tu vista para ejecutar todo el flujo.
  Future<void> handleLoginPressed({
    required GlobalKey<FormState> formKey,
    required TextEditingController usuarioController,
    required TextEditingController passwordController,
    required ValueSetter<bool> onLoginSuccessSet,
    required ValueSetter<String?> onError,
  }) async {
    if (!formKey.currentState!.validate()) return;

    const url = String.fromEnvironment('API_URL');
    if (url.isEmpty) {
      onError('No se encontró la URL de la API.');
      return;
    }

    await loadLockoutState(); // 🟡 Carga estado desde SharedPreferences

    if (isLockedOut(onError)) return;

    await login(
      url: url,
      username: usuarioController.text.trim(),
      password: passwordController.text.trim(),
      onLoginSuccessSet: onLoginSuccessSet,
      onError: onError,
    );
  }
}
