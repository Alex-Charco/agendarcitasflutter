import 'package:agendarcitasflutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:agendarcitasflutter/views/login_view.dart';
import 'login_view_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
  });

  // 🔐 Cargar dotenv ANTES de ejecutar los tests
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
  });

  group('LoginView Tests', () {
    testWidgets('🟠 Campo usuario vacío', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginView()));
      await tester.tap(find.text('Ingresar'));
      await tester.pump();
      expect(find.text('Ingresar el usuario *'), findsOneWidget);
    });
  });

  testWidgets('🟠 Campo contraseña vacío', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));
    await tester.tap(find.text('Ingresar'));
    await tester.pump();
    expect(find.text('Ingresar la contraseña *'), findsOneWidget);
  });

  testWidgets('🟠 Contraseña demasiado corta', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));
    await tester.enterText(find.byType(TextFormField).at(0), 'usuario_test');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Ingresar'));
    await tester.pump();
    expect(find.text('La contraseña debe tener al menos 10 caracteres'),
        findsOneWidget);
  });

  // ✅ Nuevo test agregado aquí
  testWidgets('🟢 El botón Ingresar está presente', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));
    expect(find.text('Ingresar'), findsOneWidget);
  });

  // ignore: unused_element
  Widget createTestableWidget(Widget child) {
  return MaterialApp(
    home: child,
    onGenerateRoute: AppRoutes.onGenerateRoute, // solo si usas rutas con nombre
  );
}

  testWidgets('🟢 Redirección correcta a HomeView cuando id_rol es 1', (tester) async {
  // 1. Mocks
  when(mockHttpClient.post(
    Uri.parse(dotenv.env['API_URL']!),
    headers: anyNamed('headers'),
    body: anyNamed('body'),
  )).thenAnswer((_) async {
    return http.Response(
      '''
      {
        "token": "fake_token",
        "user": {
          "rol": {
            "id_rol": 1
          },
          "identificacion": "123456"
        }
      }
      ''',
      200,
    );
  });

  SharedPreferences.setMockInitialValues({});

  // 2. Variable bandera para verificar navegación
  bool navigatedToHome = false;

  // 3. Montamos LoginView con callback inyectado
  await tester.pumpWidget(
    MaterialApp(
      home: LoginView(
        httpClient: mockHttpClient,
        onLoginSuccess: (context, idRol) {
          if (idRol == 1) navigatedToHome = true;
        },
      ),
    ),
  );

  // 4. Rellenar y enviar
  await tester.enterText(find.byType(TextFormField).at(0), 'usuario_valido');
  await tester.enterText(find.byType(TextFormField).at(1), 'contraseña_valida');
  await tester.tap(find.text('Ingresar'));

  // 5. Espera a que el Timer dispare y animaciones se asienten
  await tester.pump(); // inicia el login
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();

  // 6. Verificación
  expect(navigatedToHome, isTrue);
});


}
