import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:agendarcitasflutter/views/reset_password_view.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(); // Evita NotInitializedError
  });

  testWidgets('🟠 Campo email vacío muestra mensaje de error', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordView()));

    await tester.tap(find.text('Enviar'));
    await tester.pump(); // Procesa los cambios en el UI

    expect(find.text('Por favor ingresa un correo electrónico.'), findsOneWidget);
  });
  
}
