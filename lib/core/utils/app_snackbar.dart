import 'package:flutter/material.dart';
import 'package:messenger_app/core/utils/snack_bar_type.dart';
import 'package:messenger_app/theme/figma_colors.dart';

// Hiện SnackBar ở đâu cũng được, không cần context
// Ví dụ: AppSnackBar.error('Có lỗi xảy ra')
class AppSnackBar {
  // Key này đã gắn vào MaterialApp trong main.dart
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void success(String message) => show(message, SnackBarType.success);
  static void error(String message) => show(message, SnackBarType.error);
  static void warning(String message) => show(message, SnackBarType.warning);
  static void info(String message) => show(message, SnackBarType.info);

  static void show(String message, SnackBarType type) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_icon(type), color: FigmaColors.surfaceWhite),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _color(type),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static Color _color(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return FigmaColors.textGreen;
      case SnackBarType.error:
        return FigmaColors.iconRed09;
      case SnackBarType.warning:
        return FigmaColors.warning;
      case SnackBarType.info:
        return FigmaColors.surfaceNeutral02;
    }
  }

  static IconData _icon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle;
      case SnackBarType.error:
        return Icons.error;
      case SnackBarType.warning:
        return Icons.warning;
      case SnackBarType.info:
        return Icons.info;
    }
  }
}
