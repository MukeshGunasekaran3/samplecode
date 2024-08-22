import 'dart:math';
import 'dart:ui';

import 'package:intl/intl.dart';

Color getRandomPastelColor() {
  final Random random = Random();
  // Generate random values for R, G, and B components with moderate brightness
  int r = (random.nextInt(100) + 100); // Values between 100 and 200
  int g = (random.nextInt(100) + 100); // Values between 100 and 200
  int b = (random.nextInt(100) + 100); // Value// Values between 50 and 150
  return Color.fromARGB(255, r, g, b);
}

String formatDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
  return formattedDate;
}
