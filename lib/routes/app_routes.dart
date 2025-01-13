import 'package:agendarcitasflutter/views/login_view.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginView());
      default:
        // Ruta por defecto para casos no manejados.
        return MaterialPageRoute(builder: (_) => LoginView());
    }
  }
}
