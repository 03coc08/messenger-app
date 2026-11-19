import 'package:flutter/material.dart';
import 'package:messenger_app/theme/figma_colors.dart';
import 'package:messenger_app/theme/app_theme.dart';
import 'package:messenger_app/screens/chats_page.dart';
import 'package:messenger_app/screens/discover_page.dart';
import 'package:messenger_app/screens/people_screen.dart';
import 'package:messenger_app/models/session.dart';
import 'package:messenger_app/services/mattermost_api.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key, required this.session, required this.api});

  final Session session;
  final MattermostApi api;

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    ChatsPage(session: widget.session, api: widget.api),
    const PeopleScreen(),
    const DiscoverPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        key: const Key('messengerScreen'),
        body: SafeArea(
          bottom: false,
          child: IndexedStack(index: _currentIndex, children: _pages),
        ),
        bottomNavigationBar: NavigationBar(
          height: 70,
          backgroundColor: FigmaColors.surfaceNeutral,
          indicatorColor: FigmaColors.surfaceBrandPrimary02.withValues(
            alpha: 0.2,
          ),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Chats',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline_rounded),
              selectedIcon: Icon(Icons.people_rounded),
              label: 'People',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: 'Discover',
            ),
          ],
        ),
      ),
    );
  }
}
