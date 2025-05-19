import 'package:flutter/material.dart';

class BannerButton {
  final String text;
  final String link;
  final String variant;

  BannerButton(
      {required this.text, required this.link, this.variant = "primary"});
}

class BannerWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<BannerButton> buttons;

  const BannerWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.buttons = const [],
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.4, // 40% de la altura de pantalla
      width: double.infinity,
      child: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: imageUrl.startsWith('http')
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : Image.asset(imageUrl, fit: BoxFit.cover),
          ),

          // Capa azul con opacidad
          Positioned.fill(
            child: Container(color: Colors.blue.shade900.withOpacity(0.5)),
          ),

          // Contenido
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 16 : 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: buttons.map((btn) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btn.variant == "primary"
                              ? const Color.fromARGB(255, 0, 74, 173)
                              : Colors.grey[300],
                          foregroundColor: btn.variant == "primary"
                              ? Colors.white
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, btn.link);
                        },
                        child: Text(btn.text),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
