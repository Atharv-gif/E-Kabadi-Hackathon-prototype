class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String timestamp;
  final bool isRead;
  final String type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });
}
