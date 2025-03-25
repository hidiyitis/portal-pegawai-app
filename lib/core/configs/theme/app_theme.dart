import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class AppTheme {
  static final appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.background,
      contentTextStyle: TextStyle(color: AppColors.primary),
    ),
    fontFamily: 'Inter-Regular',
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      outlineBorder: BorderSide(color: AppColors.background, width: 1.5),
      hintStyle: TextStyle(
        color: AppColors.onSecondary,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: EdgeInsets.all(16),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(8),
      //   borderSide: BorderSide(color: AppColors.background),
      // ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        textStyle: TextStyle(
          fontSize: AppTextSize.bodyMedium,
          fontWeight: FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
