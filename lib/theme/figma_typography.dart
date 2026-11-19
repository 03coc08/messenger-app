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

  // text color
  static const textPrimary = Color(0xFF141F33);
  static const textLabel = Color(0xFF263040);

  // Các TextStyle ghép sẵn từ token ở trên.
  static const heading28 = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: fontSizeHeading28,
    fontWeight: fontWeightSemiBold,
    letterSpacing: letterSpacing0,
    color: textPrimary,
  );

  static const body14 = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: fontSizeBody14,
    fontWeight: fontWeightRegular,
    letterSpacing: letterSpacing0,
    color: textPrimary,
  );

  static const label11 = TextStyle(
    fontFamily: fontFamilyInter,
    fontSize: fontSizeLabel11,
    fontWeight: fontWeightRegular,
    letterSpacing: letterSpacing0,
    height: lineHeightLabel15 / fontSizeLabel11,
    color: textLabel,
  );
}
