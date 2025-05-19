import 'package:flutter/material.dart';

class UserInitialsAvatar extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  const UserInitialsAvatar({
    super.key,
    required this.firstName,
    required this.lastName,
    this.radius = 20,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.blue,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    String initials = '';
    if (firstName != null && firstName!.isNotEmpty) {
      initials += firstName![0].toUpperCase();
    }
    if (lastName != null && lastName!.isNotEmpty) {
      initials += lastName![0].toUpperCase();
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        initials,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
