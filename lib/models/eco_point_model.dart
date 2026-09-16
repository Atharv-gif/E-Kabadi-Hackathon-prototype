class EcoPointModel {
  final String id;
  final int points;
  final String type; // 'earned', 'redeemed'
  final String title;
  final String description;
  final String timestamp;

  const EcoPointModel({
    required this.id,
    required this.points,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}
