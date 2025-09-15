import 'package:flutter/material.dart';

class CalmTheme {
  // Earthy & Calming Colors
  static const Color primaryGreen = Color(0xFF6B8E6B);
  static const Color lightGreen = Color(0xFF8FBC8F);
  static const Color sage = Color(0xFF9CAF88);
  static const Color cream = Color(0xFFF7F5F3);
  static const Color warmWhite = Color(0xFFFAF9F7);
  static const Color softBeige = Color(0xFFE8E2DB);
  static const Color charcoal = Color(0xFF4A4A4A);
  static const Color mutedGray = Color(0xFF8B8B8B);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9B9B9B);
  
  // Background Colors
  static const Color background = warmWhite;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFCFBF9);
  
  // Accent Colors
  static const Color accentBlue = Color(0xFF7B9BB8);
  static const Color accentLavender = Color(0xFFB5A7C7);
  
  // Typography
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w300,
    color: textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: -0.3,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textTertiary,
  );

  // Button Styles
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primaryGreen,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
  
  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: surface,
    foregroundColor: primaryGreen,
    elevation: 0,
    side: BorderSide(color: primaryGreen.withOpacity(0.3)),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Common Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
}
