import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/domain/entities/app_theme.dart' as entity;
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'theme_extensions.dart';

class AppTheme {
  AppTheme._();
  /*
   * Dynamic Theme System
   * - appTheme parametresi ile farklı renkler kullanılabilir
   * - extensions ile custom theme data'sını ThemeData'ya ekliyoruz
   * - Gradient colors gibi custom değerler Theme.of(context).extension ile erişilebilir
   */
  static ThemeData darkTheme([entity.AppTheme? appTheme]) {
    final theme = appTheme ?? entity.AppTheme.netflixRed;
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      brightness: Brightness.dark,
      extensions: [ThemeGradientColors(gradientColors: theme.gradientColors)],
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: theme.primary,
        onPrimary: AppColors.white,
        secondary: theme.secondary,
        onSecondary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        surface: theme.bgDark,
        onSurface: AppColors.white,
      ),
      scaffoldBackgroundColor: theme.bgDark,
      textTheme: TextTheme(
        displayLarge: AppTypography.heading1,
        displayMedium: AppTypography.heading2,
        displaySmall: AppTypography.heading3,
        headlineMedium: AppTypography.heading4,
        headlineSmall: AppTypography.heading5,
        titleLarge: AppTypography.heading6,
        bodyLarge: AppTypography.bodyLargeRegular,
        bodyMedium: AppTypography.bodyNormalRegular,
        bodySmall: AppTypography.bodySmallRegular,
        labelLarge: AppTypography.bodyLargeSemibold,
        labelMedium: AppTypography.bodyNormalSemibold,
        labelSmall: AppTypography.bodySmallSemibold,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTypography.heading5.copyWith(color: AppColors.white),
        iconTheme: IconThemeData(color: AppColors.white, size: 24.w),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primary,
          foregroundColor: AppColors.white,
          textStyle: AppTypography.bodyLargeSemibold,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.white,
          textStyle: AppTypography.bodyNormalSemibold,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          textStyle: AppTypography.bodyLargeSemibold,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          side: BorderSide(color: AppColors.white20, width: 1.w),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white5,
        hintStyle: AppTypography.bodyNormalRegular.copyWith(
          color: AppColors.white50,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(color: AppColors.white20, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(color: AppColors.white20, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(color: theme.primary, width: 1.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(color: AppColors.white20, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: BorderSide(color: AppColors.error, width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: theme.bgDark,
        selectedItemColor: theme.primary,
        unselectedItemColor: AppColors.white60,
        selectedLabelStyle: AppTypography.bodySmallSemibold,
        unselectedLabelStyle: AppTypography.bodySmallRegular,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.white5,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: BorderSide(color: AppColors.white10, width: 1.w),
        ),
      ),
      iconTheme: IconThemeData(color: AppColors.white, size: 24.w),
      dividerTheme: DividerThemeData(
        color: AppColors.white10,
        thickness: 1.w,
        space: 1.h,
      ),
    );
  }

  static ThemeData lightTheme([entity.AppTheme? appTheme]) {
    final theme = appTheme ?? entity.AppTheme.netflixRed;
    return darkTheme(theme).copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: theme.primary,
        onPrimary: AppColors.white,
        secondary: theme.secondary,
        onSecondary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.black,
      ),
    );
  }
}
