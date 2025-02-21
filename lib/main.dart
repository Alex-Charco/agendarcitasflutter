//import 'package:agendarcitasflutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'firebase/firebase_options.dart';

void main() async {
  /*WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: const ValueKey('MaterialApp'),
      debugShowCheckedModeBanner: false,
      title: 'Agendamiento de citas médicas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light, 
        ),
        useMaterial3: true, 
      ),
      //onGenerateRoute: AppRoutes.onGenerateRoute,
      //initialRoute: AppRoutes.login,
    );
  }
}
