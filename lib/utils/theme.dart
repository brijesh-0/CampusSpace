import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xFF0066FF),
      brightness: Brightness.light,
      inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0066FF)),
          ),
          //labelStyle: TextStyle(color: Colors.black),
          floatingLabelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.roboto(fontSize: 16),
        displayMedium: GoogleFonts.roboto(fontSize: 16),
        labelMedium: GoogleFonts.roboto(fontSize: 14),
      ));
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      brightness: Brightness.dark,
      textTheme: TextTheme(bodyMedium: GoogleFonts.poppins()));
}
