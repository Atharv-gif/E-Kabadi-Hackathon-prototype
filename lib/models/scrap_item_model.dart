class ScrapItemModel {
  final String id;
  final String category;
  final String subType;
  final double weightKg;
  final double pricePerKg;
  final double estimatedTotal;
  final double confidenceScore;
  final String notes;

  const ScrapItemModel({
    required this.id,
    required this.category,
    required this.subType,
    required this.weightKg,
    required this.pricePerKg,
    required this.estimatedTotal,
    required this.confidenceScore,
    this.notes = '',
  });

  factory ScrapItemModel.fromJson(Map<String, dynamic> json) {
    return ScrapItemModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      subType: json['subType'] ?? '',
      weightKg: (json['weightKg'] ?? 0.0).toDouble(),
      pricePerKg: (json['pricePerKg'] ?? 0.0).toDouble(),
      estimatedTotal: (json['estimatedTotal'] ?? 0.0).toDouble(),
      confidenceScore: (json['confidenceScore'] ?? 0.95).toDouble(),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'subType': subType,
      'weightKg': weightKg,
      'pricePerKg': pricePerKg,
      'estimatedTotal': estimatedTotal,
      'confidenceScore': confidenceScore,
      'notes': notes,
    };
  }
}
