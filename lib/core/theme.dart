import 'package:flutter/material.dart';

ThemeData lightheme = ThemeData(
    useMaterial3: false,
    fontFamily: "Inter",
    appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(primary: Color.fromRGBO(9, 101, 218, 1)));
Color maincolor = Color.fromRGBO(9, 101, 218, 1);
