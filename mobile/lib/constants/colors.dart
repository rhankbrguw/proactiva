import 'package:flutter/material.dart';

class AppColors {
  // Enterprise Canvas & Neutral Scale (Zinc / Slate)
  static const Color primary = Color(0xFF0F172A); // Midnight Navy Slate
  static const Color primarySubtle = Color(0xFF334155);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surfaceAlt = Color(0xFFF1F5F9);
  
  // Precise Hairline Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFCBD5E1);

  // High-Contrast Typography
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Indicators (Desaturated, High-End Enterprise Accents)
  static const Color amber = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color red = Color(0xFFDC2626);
  static const Color redLight = Color(0xFFFEE2E2);
  static const Color green = Color(0xFF059669);
  static const Color greenLight = Color(0xFFD1FAE5);
  static const Color blue = Color(0xFF2563EB);
  static const Color blueLight = Color(0xFFDBEAFE);

  // Semantic Aliases
  static const Color accent = amber;
  static const Color accentLight = amberLight;
  static const Color danger = red;
  static const Color dangerLight = redLight;
  static const Color success = green;
  static const Color successLight = greenLight;
  static const Color info = blue;
  static const Color infoLight = blueLight;
}
