import 'package:flutter/material.dart';
import 'package:messenger_app/theme/figma_colors.dart';
import 'package:messenger_app/theme/figma_typography.dart';
import 'package:messenger_app/widgets/app_text_field.dart';
import 'package:messenger_app/widgets/community_card.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        const Text('Discover', style: FigmaTypography.heading28),
        const SizedBox(height: 16),
        const AppTextField(isSearch: true, hint: 'Search communities'),
        const SizedBox(height: 24),
        Text('Suggested', style: FigmaTypography.body14SemiBold),
        const SizedBox(height: 12),
        CommunityCard(
          title: 'Football fans',
          subtitle: 'News, highlights and conversations.',
          icon: Icons.sports_soccer_rounded,
          color: FigmaColors.textGreen,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        CommunityCard(
          title: 'Flutter developers',
          subtitle: 'Share ideas and build beautiful apps.',
          icon: Icons.flutter_dash_rounded,
          color: FigmaColors.surfaceBrandPrimary,
          onTap: () {},
        ),
      ],
    );
  }
}
