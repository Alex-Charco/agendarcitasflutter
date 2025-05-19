import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color:  Colors.grey[300],
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '© 2025 Hospital de Brigada de Selva No.17 “Pastaza”. \nTodos los derechos reservados.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
