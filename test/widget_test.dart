import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agendarcitasflutter/main.dart';
import 'package:agendarcitasflutter/views/home_view.dart';

void main() {
  // 📌 Prueba 1: Verifica que la app se carga sin errores
  testWidgets('Carga la aplicación sin errores', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MyApp), findsOneWidget);
  });

  // 📌 Prueba 2: Verifica que HomeView se renderiza correctamente
  testWidgets('HomeView muestra el título y mensaje de bienvenida', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeView()));

    expect(find.text('Agendamiento de citas médicas'), findsOneWidget);
    expect(find.text('Bienvenido a la página principal'), findsOneWidget);
  });

  // 📌 Prueba 3: Verifica que el Scaffold está presente en HomeView
  testWidgets('HomeView contiene un Scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeView()));

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
