import 'package:flutter/material.dart';
import 'package:messenger_app/theme/figma_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: FigmaColors.surfaceBrandPrimary02,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: FigmaColors.surfaceWhite03,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FigmaColors.surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: FigmaColors.iconNeutral08),
        ),
      ),
    );
  }

  /// Theme dùng cho khu vực Messenger (nền tối).
  static ThemeData get dark {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: FigmaColors.surfaceBlack,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FigmaColors.artworkNeutral07,
        hintStyle: const TextStyle(color: FigmaColors.effectNeutral02),
        prefixIconColor: FigmaColors.effectNeutral02,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
