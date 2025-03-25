import 'package:flutter/material.dart';
import 'package:agendarcitasflutter/views/login_view.dart';
import 'package:agendarcitasflutter/views/home_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? login;

    switch (routeName) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
	  case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
