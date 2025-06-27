import 'package:blogs_app/core/Themes/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 3),
  );
  static final darkModeTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppPallete.backgroundColor),
    chipTheme: ChipThemeData(color: WidgetStatePropertyAll(AppPallete.backgroundColor), side: BorderSide.none),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      focusedBorder: _border(AppPallete.gradient2),
      enabledBorder: _border(),
      errorBorder: _border(AppPallete.errorColor),
    ),
  );
}
