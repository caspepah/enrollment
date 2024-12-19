import 'package:flutter/material.dart';

class AppTheme {
  // Retro Colors
  static const Color primaryColor = Color(0xFF2A4858);    // Deep Teal
  static const Color secondaryColor = Color(0xFFE8B059);  // Vintage Gold
  static const Color accentColor = Color(0xFFD65C5C);     // Retro Red
  static const Color backgroundColor = Color(0xFFF5E6D3);  // Cream Paper
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2A4858);     // Deep Teal
  static const Color textSecondary = Color(0xFF6B4423);   // Vintage Brown
  static const Color textLight = Color(0xFFF5E6D3);       // Cream Paper
  
  // Additional Colors
  static const Color errorColor = Color(0xFFD65C5C);      // Retro Red
  static const Color successColor = Color(0xFF739E82);    // Vintage Green
  static const Color cardColor = Color(0xFFFFF8EC);       // Light Cream
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2A4858), Color(0xFF3A5D6F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: 1.2,
    fontFamily: 'Playfair Display',
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    letterSpacing: 0.8,
    fontFamily: 'Roboto Slab',
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textPrimary,
    fontFamily: 'Roboto Slab',
  );
  
  // Input Decoration
  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: secondaryColor),
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: secondaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: secondaryColor.withOpacity(0.5), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: secondaryColor, width: 2),
      ),
      labelStyle: TextStyle(
        color: textSecondary,
        fontFamily: 'Roboto Slab',
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
  
  // Button Style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: textLight,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 4,
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontFamily: 'Roboto Slab',
    ),
  );
}
