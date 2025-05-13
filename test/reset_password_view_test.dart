import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:agendarcitasflutter/views/reset_password_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/testing.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(); // Evita NotInitializedError
  });

  testWidgets('✅ Campo email vacío muestra mensaje de error', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordView()));

    await tester.tap(find.text('Enviar'));
    await tester.pump(); // Procesa los cambios en el UI

    expect(
        find.text('Por favor ingresa un correo electrónico.'), findsOneWidget);
  });

  testWidgets('✅ Correo inválido muestra mensaje de error', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordView()));

    // Escribimos un correo no válido
    await tester.enterText(find.byType(TextField), 'correo@invalido');

    // Tocamos el botón
    await tester.tap(find.byKey(const Key('send_reset_button')));
    await tester.pump();

    expect(find.text('Por favor ingresa un correo electrónico válido.'),
        findsOneWidget);
  });

  testWidgets('✅ El título de la pantalla se muestra correctamente',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordView()));

    expect(find.text('Recuperar Contraseña'), findsOneWidget);
  });

  testWidgets('✅ Enviar correo exitoso muestra el mensaje de éxito',
      (tester) async {
    final mockClient = MockClient((http.Request request) async {
      // Puedes validar aquí si quieres
      return http.Response(jsonEncode({'message': 'Correo enviado'}), 200);
    });

    await tester.pumpWidget(MaterialApp(
      home: ResetPasswordView(httpClient: mockClient),
    ));

    await tester.enterText(find.byType(TextField), 'test@example.com');
    await tester.tap(find.byKey(const Key('send_reset_button')));
    await tester.pumpAndSettle();

    expect(find.text('Solicitud enviada'), findsOneWidget);
    expect(find.text('Correo enviado'), findsOneWidget);
  });
}
