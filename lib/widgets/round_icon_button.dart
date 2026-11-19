import 'package:flutter/material.dart';
import 'package:messenger_app/theme/figma_colors.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      iconSize: 20,
      style: IconButton.styleFrom(
        backgroundColor: FigmaColors.artworkNeutral07,
      ),
      icon: icon,
    );
  }
}
