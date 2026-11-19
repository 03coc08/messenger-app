import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messenger_app/theme/figma_colors.dart';
import 'package:messenger_app/theme/figma_sizes.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: FigmaColors.artworkNeutral07,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.18),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: FigmaColors.effectNeutral02),
        ),
        trailing: SvgPicture.asset(
          'assets/icons/collapse_input.svg',
          height: FigmaSizes.size16,
        ),
        onTap: onTap,
      ),
    );
  }
}
