import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: TextTheme(bodyMedium: GoogleFonts.poppins(fontSize: 16)));
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: TextTheme(bodyMedium: GoogleFonts.poppins()));
}
