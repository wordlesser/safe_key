import 'package:flutter/material.dart';

/// 浅色（白色）主题色板 —— Apple Design / iOS 风格
class AppColors {
  // ── 背景层次 ─────────────────────────────────────────────────────
  /// 主背景：纯白
  static const Color background = Color(0xFFFFFFFF);
  /// 卡片 / 次级背景：极浅灰
  static const Color surface = Color(0xFFF5F5F7);
  /// 三级背景
  static const Color surfaceVariant = Color(0xFFEBEBF0);

  // ── 品牌色 ───────────────────────────────────────────────────────
  /// 主色：iOS 系统靛蓝（Indigo）
  static const Color primary = Color(0xFF5856D6);
  static const Color primaryVariant = Color(0xFF4947BA);
  /// 次色：iOS 系统天蓝
  static const Color secondary = Color(0xFF34AADC);

  // ── 状态色 ───────────────────────────────────────────────────────
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color success = Color(0xFF34C759);

  // ── 文字 ─────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF636366);
  static const Color textHint = Color(0xFFC7C7CC);

  // ── 边框 / 分割线 ────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E5EA);
  static const Color divider = Color(0xFFE5E5EA);

  // ── 输入框背景 ───────────────────────────────────────────────────
  static const Color inputBackground = Color(0xFFF5F5F7);

  // ── 密码分类标签色（iOS 系统色）────────────────────────────────────
  static const Color categorySocial = Color(0xFF007AFF);   // 社交 — iOS 蓝
  static const Color categoryFinance = Color(0xFF34C759);  // 金融 — iOS 绿
  static const Color categoryShopping = Color(0xFFFF2D55); // 购物 — iOS 粉红
  static const Color categoryGame = Color(0xFF5856D6);     // 游戏 — iOS 靛蓝
  static const Color categoryOther = Color(0xFFFF9500);    // 其他 — iOS 橙
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        surface: AppColors.surface,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        onSurface: AppColors.textPrimary,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        outline: AppColors.border,
        surfaceContainerHighest: AppColors.surfaceVariant,
      ),
      fontFamily: 'SF Pro Display',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: AppColors.border,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: 15,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.border;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.border,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.1),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: AppColors.primary,
      ),
    );
  }

  /// 保留 darkTheme 引用，以备需要
  static ThemeData get darkTheme => lightTheme;
}
