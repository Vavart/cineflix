// Basic imports
import 'package:flutter/material.dart';

class Utils {

  // Convert hex color to Color
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }

}