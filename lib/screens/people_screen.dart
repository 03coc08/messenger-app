import 'package:flutter/material.dart';
import 'package:messenger_app/theme/figma_colors.dart';
import 'package:messenger_app/theme/figma_typography.dart';
import 'package:messenger_app/widgets/app_text_field.dart';
import 'package:messenger_app/widgets/svg_icon.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  static const _people = <_Person>[
    _Person('Martin', 'assets/images/avatar.png', 'Active now', true),
    _Person('Neymar Jr.', 'assets/images/neymar.png', 'Active now', true),
    _Person('Lamine Yamal', 'assets/images/yamal.png', 'Active 5m ago', false),
    _Person('Gareth Bale', 'assets/images/bale.png', 'Active 10m ago', false),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 21,
                  backgroundImage: AssetImage('assets/images/messi.png'),
                ),
                const SizedBox(width: 12),
                const Text('People', style: FigmaTypography.heading28),
                const Spacer(),
                IconButton.filled(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: FigmaColors.artworkNeutral07,
                  ),
                  icon: const SvgIcon(
                    'assets/icons/add_contact.svg',
                    size: 22,
                    color: FigmaColors.surfaceWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          sliver: SliverToBoxAdapter(child: AppTextField(isSearch: true)),
        ),
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          sliver: SliverToBoxAdapter(child: _StoryAction()),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverList.separated(
            itemCount: _people.length,
            separatorBuilder: (_, _) => const Divider(indent: 76),
            itemBuilder: (context, index) {
              final person = _people[index];
              return ListTile(
                minTileHeight: 68,
                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                leading: _PersonAvatar(person: person),
                title: Text(person.name, style: FigmaTypography.body14SemiBold),
                subtitle: Text(
                  person.status,
                  style: FigmaTypography.body14.copyWith(
                    color: FigmaColors.effectNeutral02,
                  ),
                ),
                trailing: IconButton(
                  tooltip: 'Say hello',
                  onPressed: () {},
                  icon: const SvgIcon(
                    'assets/icons/wave.svg',
                    size: 22,
                    color: FigmaColors.warning,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StoryAction extends StatelessWidget {
  const _StoryAction();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: FigmaColors.artworkNeutral07,
          child: SvgIcon(
            'assets/icons/add.svg',
            size: 22,
            color: FigmaColors.surfaceWhite,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your story', style: FigmaTypography.body14SemiBold),
            SizedBox(height: 2),
            Text(
              'Share a photo or write something',
              style: FigmaTypography.body14.copyWith(
                color: FigmaColors.effectNeutral02,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PersonAvatar extends StatelessWidget {
  const _PersonAvatar({required this.person});

  final _Person person;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 50,
      child: Stack(
        children: [
          CircleAvatar(radius: 25, backgroundImage: AssetImage(person.avatar)),
          if (person.isOnline)
            Positioned(
              right: 0,
              bottom: 1,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: FigmaColors.textGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: FigmaColors.surfaceBlack, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Person {
  const _Person(this.name, this.avatar, this.status, this.isOnline);

  final String name;
  final String avatar;
  final String status;
  final bool isOnline;
}
