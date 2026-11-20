import 'package:flutter/material.dart';

// Typography lấy từ Figma (collection Messenger Typography, mode Original).
abstract final class FigmaTypography {
  // font-family
  static const fontFamilyInter = 'Inter';

  // font-style
  static const fontWeightSemiBold = FontWeight.w600;
  static const fontWeightRegular = FontWeight.w400;

  // font-size
  static const fontSizeHeading28 = 28.0;
  static const fontSizeBody14 = 14.0;
  static const fontSizeLabel11 = 11.0;

  // letter-spacing
  static const letterSpacing0 = 0.0;

  // line-height (px). Flutter dùng hệ số nhân nên chia cho font size.
  static const lineHeightLabel15 = 15.0;

  // Các TextStyle ghép sẵn từ token ở trên. Không gắn màu: màu chữ lấy từ
  // FigmaColors tại nơi dùng, bằng .copyWith(color: FigmaColors.xxx).
  static const heading28 = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: fontSizeHeading28,
    fontWeight: fontWeightSemiBold,
    letterSpacing: letterSpacing0,
  );

  static const body14 = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: fontSizeBody14,
    fontWeight: fontWeightRegular,
    letterSpacing: letterSpacing0,
  );

  static const label11 = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: fontSizeLabel11,
    fontWeight: fontWeightRegular,
    letterSpacing: letterSpacing0,
    height: lineHeightLabel15 / fontSizeLabel11,
  );

  // heading28 / body14 / label11 là 3 kiểu chữ có trong Figma. Chữ đậm cỡ 14
  // (tên người, tiêu đề mục) ghép từ body14 và font style Semi Bold.
  static const body14SemiBold = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: fontSizeBody14,
    fontWeight: fontWeightSemiBold,
    letterSpacing: letterSpacing0,
  );

  // TextTheme dùng chung cho toàn app (gắn vào AppTheme). Text không đặt style
  // sẽ tự theo body14. Màu chữ để theme tự quyết định theo nền sáng/tối.
  static const textTheme = TextTheme(
    displayLarge: heading28,
    displayMedium: heading28,
    displaySmall: heading28,
    headlineLarge: heading28,
    headlineMedium: heading28,
    headlineSmall: heading28,
    titleLarge: heading28,
    titleMedium: body14SemiBold,
    titleSmall: body14SemiBold,
    bodyLarge: body14,
    bodyMedium: body14,
    bodySmall: label11,
    labelLarge: body14SemiBold,
    labelMedium: label11,
    labelSmall: label11,
  );
}
