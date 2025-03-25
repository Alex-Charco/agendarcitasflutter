import 'package:flutter/material.dart';
import 'package:agendarcitasflutter/views/login_view.dart';
import 'package:agendarcitasflutter/views/home_view.dart';
import 'package:agendarcitasflutter/views/reset_password_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String reset = '/reset';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? login;

    switch (routeName) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
	  case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
	  case reset:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
