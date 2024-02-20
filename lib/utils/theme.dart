import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomAppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkBackgroundColor,
    hintColor: Colors.blue,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.grey),
      titleLarge: TextStyle(color: Colors.yellow),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightBackgroundColor,
    hintColor: Colors.red,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.grey),
      titleLarge: TextStyle(color: Colors.yellow),
    ),
  );
}
