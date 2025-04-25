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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.onBackground,
      selectedItemColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
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
      counterStyle: TextStyle(color: AppColors.primary),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
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
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(color: AppColors.onPrimary),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: AppColors.primary,
      headerForegroundColor: Colors.white,
      dayBackgroundColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.white;
      }),
      todayBackgroundColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.white;
      }),
      dayStyle: TextStyle(color: AppColors.onPrimary),
      yearStyle: TextStyle(color: AppColors.onPrimary),
      weekdayStyle: TextStyle(color: AppColors.onPrimary),
      dividerColor: AppColors.primary,
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.white;
      }),
      hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? Colors.white
            : AppColors.onPrimary;
      }),
      dayPeriodColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.white;
      }),
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? Colors.white
            : AppColors.onPrimary;
      }),
      dialHandColor: AppColors.primary,
      dialBackgroundColor: Colors.white,
      entryModeIconColor: AppColors.primary,
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
    popupMenuTheme: PopupMenuThemeData(color: Colors.white),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue; // Selected color
        }
        return Colors.transparent; // Unselected color
      }),
    ),
  );
}
