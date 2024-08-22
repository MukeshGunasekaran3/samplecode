import 'package:flutter/material.dart';

dynamic showSnackbar(dynamic context, String message, Color color) {
  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // duration: Duration(seconds: 8),
      content: Text(
        message,
        style: const TextStyle(fontSize: 14.0, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
      elevation: 20,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      behavior: SnackBarBehavior.fixed,
    ),
  );
}