import 'package:flutter/material.dart';

// Màu lấy từ file Figma của app
abstract final class AppColors {
  // ---------- Màu thương hiệu ----------
  static const primary = Color(0xFF0584FE);
  static const primaryLight = Color(0xFF19A3FE);

  // ---------- Màu trạng thái ----------
  static const online = Color(0xFF5AD439);
  static const danger = Color(0xFFFE294D);

  // Figma không có màu cảnh báo nên tự thêm
  static const warning = Color(0xFFFFC83D);

  // ---------- Trắng, đen và các mức xám (sáng -> tối) ----------
  static const white = Color(0xFFFFFFFF);
  static const gray50 = Color(0xFFFCFCFE);
  static const gray200 = Color(0xFFE7E7E7);
  static const gray400 = Color(0xFFABABAB);
  static const gray500 = Color(0xFF8E8E93);
  static const gray600 = Color(0xFF898A8D);
  static const gray700 = Color(0xFF434343);
  static const gray800 = Color(0xFF242424);
  static const gray900 = Color(0xFF171717);
  static const gray950 = Color(0xFF060606);
  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);

  // ---------- Lớp phủ trắng trong suốt (số là % độ đục) ----------
  static const white20 = Color(0x33FFFFFF);
  static const white35 = Color(0x59FFFFFF);
  static const white50 = Color(0x80FFFFFF);
  static const white60 = Color(0x99FFFFFF);
  static const white70 = Color(0xB3FFFFFF);

  // ---------- Lớp phủ đen trong suốt (số là % độ đục) ----------
  static const black4 = Color(0x0A000000);
  static const black12 = Color(0x1F000000);
  static const black15 = Color(0x26000000);
  static const black20 = Color(0x33000000);
  static const black35 = Color(0x59000000);
  static const black50 = Color(0x80000000);

  // ---------- Màu cho giao diện tối ----------
  static const darkBackground = black;
  static const darkSurface = gray800;
  static const darkNavigation = gray950;
  static const darkMuted = gray600;
}
