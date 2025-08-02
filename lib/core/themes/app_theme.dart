import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color primary = Color(0xffE50914);
  static const Color secondary = Color(0xff5949E6);
  static const Color background = Color(0xFF090909);
  static const Color card = Color(0xff6F060B);
  static const Color text = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textFaded = Colors.white54;
  static const Color grey = Color(0xFF333333);
  static const Color black = Colors.black;
}

class AppTheme {
  static final ThemeData lightThemex = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Euclid',
  );

  static final ThemeData lightTheme = darkTheme.copyWith(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 25.sp,
        fontWeight: FontWeight.w900,
        color: AppColors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      headlineSmall: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
      titleLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      bodyLarge: TextStyle(fontSize: 14.sp, color: AppColors.text),
      bodyMedium: TextStyle(
        fontSize: 13.sp,
        color: AppColors.black.withOpacity(0.75),
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        color: AppColors.black.withOpacity(0.5),
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Euclid',
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
      displayMedium: TextStyle(
        fontSize: 25.sp,
        fontWeight: FontWeight.w900,
        color: AppColors.text,
      ),
      displaySmall: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      headlineSmall: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
      titleLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
      bodyLarge: TextStyle(fontSize: 14.sp, color: AppColors.text),
      bodyMedium: TextStyle(
        fontSize: 13.sp,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        color: AppColors.textFaded,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
