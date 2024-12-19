import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF2D3250);  // Deep Navy Blue
  static const Color secondaryColor = Color(0xFF7077A1); // Muted Purple
  static const Color accentColor = Color(0xFFF6B17A);   // Warm Orange
  static const Color backgroundColor = Color(0xFFF7F7F9); // Light Gray Background

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3250);   // Deep Navy Blue
  static const Color textSecondary = Color(0xFF7077A1); // Muted Purple
  static const Color textLight = Color(0xFFFFFFFF);     // White

  // Additional Colors
  static const Color errorColor = Color(0xFFE57373);    // Soft Red
  static const Color successColor = Color(0xFF81C784);  // Soft Green
  static const Color cardColor = Color(0xFFFFFFFF);     // White

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2D3250), Color(0xFF424769)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textPrimary,
  );

  // Input Decoration
  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: secondaryColor),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
      labelStyle: TextStyle(color: textSecondary),
    );
  }

  // Button Style
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: textLight,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
