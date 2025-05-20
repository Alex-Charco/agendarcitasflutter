import 'package:flutter/material.dart';
import 'package:agendarcitasflutter/widgets/custom_alert.dart';

void showErrorDialog(BuildContext context, String title, String message) {
  CustomAlert.showErrorDialog(
    context: context,
    title: title,
    message: message,
  );
}

void showSuccessDialog(BuildContext context, String title, String message, {VoidCallback? onConfirm}) {
  CustomAlert.showSuccessDialog(
    context: context,
    title: title,
    message: message,
    onConfirm: onConfirm,
  );
}
