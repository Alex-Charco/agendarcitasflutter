import 'package:flutter/material.dart';

class CardFeature extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;

  const CardFeature({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170, // ✅ Altura uniforme
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3, // ✅ Limita el texto para mantener altura
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
