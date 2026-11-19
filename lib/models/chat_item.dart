class ChatItem {
  final String channelId;
  final String name;
  final String message;
  final String time;
  final String avatar;
  final bool isOnline;
  final bool isUnread;

  const ChatItem({
    this.channelId = '',
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    this.isOnline = false,
    this.isUnread = false,
  });
}
