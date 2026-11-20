import 'package:flutter/material.dart';
import 'package:messenger_app/core/network/api_error_handler.dart';
import 'package:messenger_app/core/utils/app_snackbar.dart';
import 'package:messenger_app/models/chat_message.dart';
import 'package:messenger_app/services/mattermost_api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messenger_app/theme/app_theme.dart';
import 'package:messenger_app/theme/figma_colors.dart';
import 'package:messenger_app/theme/figma_typography.dart';
import 'package:messenger_app/theme/figma_sizes.dart';
import 'package:messenger_app/widgets/app_text_field.dart';
import 'package:messenger_app/widgets/svg_icon.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    required this.name,
    required this.avatar,
    required this.isOnline,
    this.api,
    this.currentUserId = '',
    this.channelId = '',
    super.key,
  });

  final String name;
  final String avatar;
  final bool isOnline;

  // Không truyền api thì màn hình chỉ hiện khung, không tải tin nhắn
  final MattermostApi? api;
  final String currentUserId;
  final String channelId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();

  // Tin mới nhất nằm đầu danh sách (khớp với ListView reverse)
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _error;

  bool get _canUseApi => widget.api != null && widget.channelId.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_canUseApi) _loadMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final all = await widget.api!.getPosts(widget.channelId);
      // Bỏ tin hệ thống (vào/rời kênh...), chỉ giữ tin người dùng gửi
      final messages = all.where((m) => m.type.isEmpty).toList();
      if (!mounted) return;
      setState(() {
        _messages = messages;
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

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending || !_canUseApi) return;

    setState(() => _isSending = true);
    try {
      final sent = await widget.api!.sendPost(widget.channelId, text);
      if (!mounted) return;
      _controller.clear();
      setState(() => _messages = [sent, ..._messages]);
    } catch (e, stack) {
      AppSnackBar.error(handleRequestError(e, stack).message);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark,
      child: Scaffold(
        backgroundColor: FigmaColors.surfaceBlack,
        appBar: AppBar(
          backgroundColor: FigmaColors.surfaceBlack,
          surfaceTintColor: FigmaColors.surfaceBlackOpacity0,
          titleSpacing: 0,
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.maybePop(context),
            icon: const SvgIcon('assets/icons/back.svg', size: 20),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(widget.avatar),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FigmaTypography.body14SemiBold,
                    ),
                    Text(
                      widget.isOnline ? 'Active now' : 'Messenger',
                      style: FigmaTypography.label11.copyWith(
                        color: FigmaColors.effectNeutral02,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Audio call',
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/call.svg',
                width: FigmaSizes.size24,
              ),
            ),
            IconButton(
              tooltip: 'Video call',
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/video_call.svg',
                width: FigmaSizes.size27,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _MessageComposer(
              controller: _controller,
              isSending: _isSending,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadMessages,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    // reverse: tin mới nhất ở sát ô nhập, phần giới thiệu nằm trên cùng
    return ListView.builder(
      reverse: true,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
      itemCount: _messages.length + 1,
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildUserIntro(context),
          );
        }
        final message = _messages[index];
        if (message.userId == widget.currentUserId) {
          return _SentMessage(text: message.message);
        }
        return _ReceivedMessage(avatar: widget.avatar, text: message.message);
      },
    );
  }

  Widget _buildUserIntro(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 42, backgroundImage: AssetImage(widget.avatar)),
        const SizedBox(height: 12),
        Text(widget.name, style: FigmaTypography.body14SemiBold),
        const SizedBox(height: 4),
        Text(
          "You're friends on Facebook",
          style: FigmaTypography.body14.copyWith(
            color: FigmaColors.effectNeutral02,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 70,
          height: 38,
          child: Stack(
            children: [
              const Positioned(
                left: 0,
                child: CircleAvatar(
                  radius: 19,
                  backgroundImage: AssetImage('assets/images/messi.png'),
                ),
              ),
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 19,
                  backgroundImage: AssetImage(widget.avatar),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Say hi to your Facebook friend, ${widget.name}.',
          textAlign: TextAlign.center,
          style: FigmaTypography.label11.copyWith(
            color: FigmaColors.effectNeutral02,
          ),
        ),
      ],
    );
  }
}

class _ReceivedMessage extends StatelessWidget {
  const _ReceivedMessage({required this.avatar, required this.text});

  final String avatar;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(radius: 12, backgroundImage: AssetImage(avatar)),
          const SizedBox(width: 7),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: FigmaColors.artworkNeutral07,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

class _SentMessage extends StatelessWidget {
  const _SentMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: FigmaColors.surfaceBrandPrimary02,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            text,
            style: FigmaTypography.body14.copyWith(
              color: FigmaColors.surfaceWhite,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 7, 6, 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showMediaButtons = constraints.maxWidth >= 360;
            return Row(
              children: [
                _ComposerButton(
                  icon: SvgPicture.asset('assets/icons/actions.svg'),
                ),
                if (showMediaButtons) ...[
                  _ComposerButton(
                    icon: SvgPicture.asset(
                      'assets/icons/camera.svg',
                      colorFilter: const ColorFilter.mode(
                        FigmaColors.surfaceBrandPrimary02,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  _ComposerButton(
                    icon: SvgPicture.asset('assets/icons/gallery.svg'),
                  ),
                ],
                Expanded(
                  child: AppTextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 4,
                    hint: 'Message',
                    fillColor: FigmaColors.artworkNeutral07,
                    contentPadding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icons/emoji.svg',
                        width: FigmaSizes.size24,
                      ),
                    ),
                  ),
                ),
                _ComposerButton(
                  icon: SvgPicture.asset(
                    'assets/icons/send.svg',
                    width: FigmaSizes.size24,
                    colorFilter: const ColorFilter.mode(
                      FigmaColors.surfaceBrandPrimary02,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: isSending ? null : onSend,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ComposerButton extends StatelessWidget {
  const _ComposerButton({required this.icon, this.onPressed});

  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
      visualDensity: VisualDensity.compact,
      color: FigmaColors.surfaceBrandPrimary02,
      iconSize: 22,
      icon: icon,
    );
  }
}
