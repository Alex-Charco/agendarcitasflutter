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

## Corrección de errores
1. Se deabilito **'Language Support for Java(TM) by Red Hat'** en VScode por causar errores en android/build.gradle.

2. Solución al problema en el emulador de **"Error en el servidor"**, no permitía logearse.

**Solución:**
Agregando la IP, ya que la API esta en servidor local.