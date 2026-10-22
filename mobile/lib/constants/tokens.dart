import 'package:flutter/material.dart';

class AppTokens {
  // Compact Density Spacing (4pt / 8pt Scale)
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;

  // Crisp, Subtle Radii (No puffy rounding)
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusFull = 999.0;

  // Ultra-Subtle Shadow for Enterprise Feel
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x060F172A),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> popupShadow = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 16.0,
      offset: Offset(0, 6),
    ),
  ];
}
