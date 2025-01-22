import 'package:anvaya/constants/colors.dart';
import 'package:flutter/material.dart';


class AppTheme {
  static final lightThemeMode = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.secondaryColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navbarcolorbg,
      ),
      colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor, primary: AppColors.primaryColor));
}
