# Agendamiento de citas médicas
Aplicación de agendamiento de citas médicas móvil con el framework Flutter.

## Creación del proyecto
Crear el proyecto ejecutando el comando:

    flutter create --org com.utpl agendarcitasflutter

Para ejecut elar proyecto Flutter se utiliza el comando:

	flutter run

## Instalación de despendencia

    flutter pub add firebase_performance

	flutter pub add shared_preferences
	
	flutter pub add http
	
	flutter pub add flutter_svg

	flutter pub add flutter_dotenv

Se emplea paquete flutter_dotenv de Flutter que te permite cargar variables de entorno desde un archivo .env.

## Instalación de dependencias para pruebas unitarias

	flutter pub add mockito

	dependencies:
  		mockito: ^5.4.4

	dart run build_runner build

	dev_dependencies:
 		 build_runner: ^2.3.3

	dev_dependencies:
		flutter_test:
			sdk: flutter
		mockito: ^5.4.4        # ✅ compatible con Dart 3.5.4 que se esta utilizando
		build_runner: ^2.3.3   # ✅ también compatible

## Corrección de errores
1. Se deabilito **'Language Support for Java(TM) by Red Hat'** en VScode por causar errores en android/build.gradle.

2. Solución al problema en el emulador de **"Error en el servidor"**, no permitía logearse.

**Solución:**
Agregando la IP, ya que la API esta en servidor local.