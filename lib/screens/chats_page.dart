import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messenger_app/theme/figma_colors.dart';
import 'package:messenger_app/theme/figma_sizes.dart';
import 'package:messenger_app/widgets/round_icon_button.dart';
import 'package:messenger_app/widgets/app_text_field.dart';
import 'package:messenger_app/widgets/user_avatar.dart';
import 'package:messenger_app/core/network/api_error_handler.dart';
import 'package:messenger_app/models/channel.dart';
import 'package:messenger_app/models/chat_item.dart';
import 'package:messenger_app/models/session.dart';
import 'package:messenger_app/services/mattermost_api.dart';
import 'package:messenger_app/models/story.dart';
import 'package:messenger_app/screens/chat_detail_screen.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key, required this.session, required this.api});

  final Session session;
  final MattermostApi api;

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  static const _defaultAvatar = 'assets/images/avatar.png';

  static const _stories = <Story>[
    Story('Neymar', 'assets/images/neymar.png'),
    Story('Gareth', 'assets/images/bale.png'),
    Story('Martha', 'assets/images/avatar.png'),
    Story('Yamal', 'assets/images/yamal.png'),
  ];

  List<ChatItem> _chats = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final teams = await widget.api.getMyTeams();
      if (teams.isEmpty) {
        if (!mounted) return;
        setState(() {
          _chats = [];
          _isLoading = false;
        });
        return;
      }

      // Tạm lấy team đầu tiên
      final channels = await widget.api.getMyChannels(teams.first.id);
      channels.sort((a, b) => b.lastPostAt.compareTo(a.lastPostAt));

      // Kênh tin nhắn riêng (type 'D') có tên dạng "idA__idB", cần đổi sang tên người kia
      final otherUserIds = <String>{};
      for (final c in channels) {
        final other = _otherUserId(c);
        if (other != null) otherUserIds.add(other);
      }
      final users = await widget.api.getUsersByIds(otherUserIds.toList());
      final userNames = {for (final u in users) u.id: u.displayName};

      final items = channels.map((c) {
        final other = _otherUserId(c);
        final name = other != null
            ? (userNames[other] ?? c.name)
            : (c.displayName.isNotEmpty ? c.displayName : c.name);
        return ChatItem(
          channelId: c.id,
          name: name,
          message: '',
          time: _formatTime(c.lastPostAt),
          avatar: _defaultAvatar,
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _chats = items;
        _isLoading = false;
      });
    } catch (e, stack) {
      if (!mounted) return;
      setState(() {
        _error = handleRequestError(e, stack).message;
        _isLoading = false;
      });
    }
  }

  String? _otherUserId(Channel c) {
    if (c.type != 'D') return null;
    final ids = c.name.split('__');
    for (final id in ids) {
      if (id != widget.session.userId) return id;
    }
    // Chat với chính mình
    return widget.session.userId;
  }

  String _formatTime(int millis) {
    if (millis <= 0) return '';
    final t = DateTime.fromMillisecondsSinceEpoch(millis);
    final now = DateTime.now();
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    if (t.year == now.year && t.month == now.month && t.day == now.day) {
      return '$hh:$mm';
    }
    return '${t.day}/${t.month}';
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          sliver: SliverToBoxAdapter(child: _buildHeader(context)),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
          sliver: SliverToBoxAdapter(child: AppTextField(isSearch: true)),
        ),
        SliverToBoxAdapter(child: _buildStories()),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        if (_isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (_error != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _loadChats,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          )
        else if (_chats.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('Chưa có cuộc trò chuyện nào')),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList.separated(
              itemCount: _chats.length,
              separatorBuilder: (_, _) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return ListTile(
                  minTileHeight: 72,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: UserAvatar(
                    image: chat.avatar,
                    radius: 27,
                    isOnline: chat.isOnline,
                  ),
                  title: Text(
                    chat.name,
                    style: TextStyle(
                      fontWeight: chat.isUnread
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    chat.message.isEmpty
                        ? chat.time
                        : '${chat.message}  ·  ${chat.time}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: chat.isUnread
                          ? FigmaColors.textWhiteOpacity70
                          : FigmaColors.effectNeutral02,
                    ),
                  ),
                  trailing: chat.isUnread
                      ? const CircleAvatar(
                          radius: 5,
                          backgroundColor: FigmaColors.surfaceBrandPrimary02,
                        )
                      : SvgPicture.asset(
                          'assets/icons/read.svg',
                          width: FigmaSizes.size17,
                        ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ChatDetailScreen(
                        api: widget.api,
                        currentUserId: widget.session.userId,
                        channelId: chat.channelId,
                        name: chat.name,
                        avatar: chat.avatar,
                        isOnline: chat.isOnline,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showCamera = constraints.maxWidth >= 320;
        return Row(
          children: [
            const UserAvatar(
              image: 'assets/images/messi.png',
              radius: 21,
              isOnline: true,
            ),
            const SizedBox(width: 12),
            const Text(
              'Chats',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            if (showCamera) ...[
              RoundIconButton(
                icon: SvgPicture.asset(
                  'assets/icons/camera.svg',
                  width: FigmaSizes.size20,
                  colorFilter: const ColorFilter.mode(
                    FigmaColors.surfaceWhite,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            RoundIconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  Widget _buildStories() {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _stories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(
              width: 58,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: FigmaColors.artworkNeutral07,
                    child: Icon(Icons.add_rounded),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Your story',
                    maxLines: 1,
                    style: TextStyle(
                      color: FigmaColors.effectNeutral02,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }

          final story = _stories[index - 1];
          return SizedBox(
            width: 58,
            child: Column(
              children: [
                UserAvatar(image: story.avatar, radius: 27, isOnline: true),
                const SizedBox(height: 6),
                Text(
                  story.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: FigmaColors.effectNeutral02,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
