import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const green = Color(0xFF0F6B45); // أخضر داكن (الشريط العلوي)
  static const green2 = Color(0xFF2E9E54);
  static const bg = Color(0xFFF4F8EE);
  static const cream = Color(0xFFFFF6DC);
  static const gold = Color(0xFFF5B82E);
  static const blue = Color(0xFF2F8FE5);
  static const purple = Color(0xFF7E57C9);
  static const orange = Color(0xFFF2842B);
  static const red = Color(0xFFE8556A);
  static const teal = Color(0xFF1DA89A);
}

ThemeData buildTheme() {
  final base = ThemeData(
    colorSchemeSeed: AppColors.green,
    scaffoldBackgroundColor: AppColors.bg,
    useMaterial3: true,
  );
  return base.copyWith(textTheme: GoogleFonts.cairoTextTheme(base.textTheme));
}

PreferredSizeWidget appBar(String title,
        {Color color = AppColors.green,
        IconData? icon,
        VoidCallback? onIcon,
        bool back = true}) =>
    AppBar(
      automaticallyImplyLeading: back,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: color,
      foregroundColor: Colors.white,
      centerTitle: true,
      clipBehavior: Clip.antiAlias,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [color, Color.alphaBlend(Colors.white24, color)],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))),
      actions: icon == null
          ? null
          : [
              onIcon == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(icon))
                  : IconButton(onPressed: onIcon, icon: Icon(icon)),
            ],
    );
