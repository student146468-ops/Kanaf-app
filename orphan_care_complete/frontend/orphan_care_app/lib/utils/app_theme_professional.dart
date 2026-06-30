import 'package:flutter/material.dart';

/// ألوان التطبيق الاحترافية
class AppColors {
  // ============ الألوان الأساسية ============
  static const Color brandOrange = Color(0xFFFF8C42);
  static const Color brandOrangeDark = Color(0xFFE68A00);
  static const Color brandOrangeLight = Color(0xFFFFB84D);

  // ============ الألوان الخلفية ============
  static const Color darkBg = Color(0xFF0F0F0F);
  static const Color darkBgSecondary = Color(0xFF1A1A1A);
  static const Color lightBg = Color(0xFFF5F5F5);

  // ============ الألوان الزجاجية ============
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color glassDark = Color(0xFF1F1F1F);
  static const Color glassGrey = Color(0xFFF5F5F5);
  static const Color glassBackground = glassWhite;
  static const Color glassBorder = borderLight;
  static const Color glassShadow = Color(0x1A000000);

  // ============ ألوان النصوص ============
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color glassTextPrimary = textPrimary;
  static const Color glassTextSecondary = textSecondary;
  static const Color glassTextDisabled = textTertiary;

  // ============ ألوان الحالات ============
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color warningYellow = Color(0xFFFCD34D);
  static const Color infoBlue = Color(0xFF3B82F6);

  // ============ ألوان الحدود ============
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color borderDark = Color(0xFF333333);
}

/// الثيم الاحترافي بتصميم زجاجي
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ============ Seed Color ============
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandOrange,
        brightness: Brightness.light,
      ),

      // ============ الألوان الأساسية ============
      primaryColor: AppColors.brandOrange,
      scaffoldBackgroundColor: AppColors.lightBg,

      // ============ AppBar ============
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.lightBg,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.brandOrange,
          size: 24,
        ),
      ),

      // ============ الأزرار ============
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: AppColors.brandOrange.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandOrange,
          side: const BorderSide(color: AppColors.brandOrange, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandOrange,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ============ حقول الإدخال ============
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassGrey,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        prefixIconColor: AppColors.brandOrange,
        suffixIconColor: AppColors.brandOrange,
      ),

      // ============ البطاقات ============
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.glassWhite,
        shadowColor: Colors.black.withOpacity(0.1),
      ),

      // ============ الشريط السفلي ============
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.glassWhite,
        selectedItemColor: AppColors.brandOrange,
        unselectedItemColor: AppColors.textTertiary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ============ الحوارات ============
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.glassWhite,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),

      // ============ الشرائح ============
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.brandOrange,
        inactiveTrackColor: AppColors.borderLight,
        thumbColor: AppColors.brandOrange,
        overlayColor: AppColors.brandOrange.withOpacity(0.2),
        valueIndicatorColor: AppColors.brandOrange,
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ============ الشرائط ============
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.glassDark,
        contentTextStyle: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
      ),

      // ============ الأيقونات ============
      iconTheme: const IconThemeData(
        color: AppColors.brandOrange,
        size: 24,
      ),

      // ============ الأنماط النصية ============
      textTheme: const TextTheme(
        // العناوين الكبيرة
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),

        // العناوين المتوسطة
        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        // العناوين الصغيرة
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textTertiary,
        ),

        // النصوص العادية
        bodyLarge: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        ),

        // النصوص الصغيرة
        labelLarge: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandOrange,
        brightness: Brightness.dark,
      ),
      primaryColor: AppColors.brandOrange,
      scaffoldBackgroundColor: AppColors.darkBg,
    );
  }
}

/// فئة مساعدة للحصول على الثيم الحالي
class ThemeHelper {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }
}
