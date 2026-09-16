import '../models/notification_model.dart';

abstract class NotificationService {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
}

class MockNotificationService implements NotificationService {
  final List<NotificationModel> _notifications = [
    const NotificationModel(
      id: 'N-1',
      title: 'Collector Accepted Pickup',
      message: 'Ramesh Kumar has accepted your pickup request and is on the way.',
      timestamp: '10 mins ago',
      isRead: false,
      type: 'pickup',
    ),
    const NotificationModel(
      id: 'N-2',
      title: 'Payment Received',
      message: 'Payment of ₹118 has been transferred to your UPI account.',
      timestamp: '2 hours ago',
      isRead: true,
      type: 'payment',
    ),
    const NotificationModel(
      id: 'N-3',
      title: 'Eco Points Earned!',
      message: 'You earned 20 Eco Points for recycling 4.6 kg scrap.',
      timestamp: 'Yesterday',
      isRead: true,
      type: 'reward',
    ),
    const NotificationModel(
      id: 'N-4',
      title: 'Scrap Recycled Certificate',
      message: 'Your scrap batch #EB-4912 has been processed at EcoRecycle Hub.',
      timestamp: '2 days ago',
      isRead: true,
      type: 'journey',
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    return _notifications;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final old = _notifications[index];
      _notifications[index] = NotificationModel(
        id: old.id,
        title: old.title,
        message: old.message,
        timestamp: old.timestamp,
        isRead: true,
        type: old.type,
      );
    }
  }
}
