class EcoCoinModel {
  final String id;
  final int coins;
  final String title;
  final String description;
  final String category; // 'Ration', 'Healthcare', 'Tools'
  final bool isCredit;
  final String timestamp;

  const EcoCoinModel({
    required this.id,
    required this.coins,
    required this.title,
    required this.description,
    required this.category,
    this.isCredit = true,
    required this.timestamp,
  });
}
