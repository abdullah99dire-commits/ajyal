import 'package:flutter/material.dart';

class AppColors {
  static const green = Color(0xFF1B7F4B);
  static const green2 = Color(0xFF2E9E4F);
  static const bg = Color(0xFFF3F8F1);
  static const blue = Color(0xFF2F80ED);
  static const purple = Color(0xFF7B4FD1);
  static const orange = Color(0xFFF2790F);
  static const red = Color(0xFFE0475B);
  static const teal = Color(0xFF17A2B8);
}

ThemeData buildTheme() => ThemeData(
      colorSchemeSeed: AppColors.green,
      scaffoldBackgroundColor: AppColors.bg,
      useMaterial3: true,
    );

PreferredSizeWidget appBar(String title, {Color color = AppColors.green}) =>
    AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: color,
      foregroundColor: Colors.white,
      centerTitle: true,
    );
