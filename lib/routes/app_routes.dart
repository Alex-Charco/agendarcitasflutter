import 'package:agendarcitasflutter/pages/contacto_page.dart';
import 'package:agendarcitasflutter/pages/consulta_cita_paciente_page.dart';
import 'package:agendarcitasflutter/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:agendarcitasflutter/views/login_view.dart';
import 'package:agendarcitasflutter/views/reset_password_view.dart';
import 'package:agendarcitasflutter/pages/turnos_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String reset = '/reset';
  static const String cita = '/consultar_cita';
  static const String contacto = '/contacto';
  static const String turno = '/turno';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? login;

    switch (routeName) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case reset:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView());
      case cita:
        return MaterialPageRoute(
            builder: (_) => const ConsultaCitaPacientePage());
      case contacto:
        return MaterialPageRoute(builder: (_) => const ContactoPage());
	  case turno:
        return MaterialPageRoute(builder: (_) => const TurnosPage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
