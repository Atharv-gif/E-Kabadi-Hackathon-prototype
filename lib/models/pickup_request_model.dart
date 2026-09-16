import 'scrap_item_model.dart';

enum PickupStatus {
  pending,
  accepted,
  onTheWay,
  arrived,
  verified,
  completed,
  cancelled,
}

class PickupRequestModel {
  final String id;
  final String citizenId;
  final String citizenName;
  final String citizenAddress;
  final String citizenPhone;
  final List<ScrapItemModel> items;
  final PickupStatus status;
  final double totalEstimatedPrice;
  final double finalVerifiedPrice;
  final double finalVerifiedWeight;
  final String scheduledDate;
  final String timeSlot;
  final String instructions;
  final String collectorId;
  final String collectorName;
  final String collectorPhone;
  final double collectorRating;
  final String collectorDistance;
  final String otpCode;
  final String createdAt;

  const PickupRequestModel({
    required this.id,
    required this.citizenId,
    required this.citizenName,
    required this.citizenAddress,
    required this.citizenPhone,
    required this.items,
    required this.status,
    required this.totalEstimatedPrice,
    this.finalVerifiedPrice = 0.0,
    this.finalVerifiedWeight = 0.0,
    required this.scheduledDate,
    required this.timeSlot,
    this.instructions = '',
    this.collectorId = 'COL-892',
    this.collectorName = 'Ramesh Kumar',
    this.collectorPhone = '+91 98765 43210',
    this.collectorRating = 4.8,
    this.collectorDistance = '1.2 km',
    this.otpCode = '4829',
    required this.createdAt,
  });

  PickupRequestModel copyWith({
    String? id,
    String? citizenId,
    String? citizenName,
    String? citizenAddress,
    String? citizenPhone,
    List<ScrapItemModel>? items,
    PickupStatus? status,
    double? totalEstimatedPrice,
    double? finalVerifiedPrice,
    double? finalVerifiedWeight,
    String? scheduledDate,
    String? timeSlot,
    String? instructions,
    String? collectorId,
    String? collectorName,
    String? collectorPhone,
    double? collectorRating,
    String? collectorDistance,
    String? otpCode,
    String? createdAt,
  }) {
    return PickupRequestModel(
      id: id ?? this.id,
      citizenId: citizenId ?? this.citizenId,
      citizenName: citizenName ?? this.citizenName,
      citizenAddress: citizenAddress ?? this.citizenAddress,
      citizenPhone: citizenPhone ?? this.citizenPhone,
      items: items ?? this.items,
      status: status ?? this.status,
      totalEstimatedPrice: totalEstimatedPrice ?? this.totalEstimatedPrice,
      finalVerifiedPrice: finalVerifiedPrice ?? this.finalVerifiedPrice,
      finalVerifiedWeight: finalVerifiedWeight ?? this.finalVerifiedWeight,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      instructions: instructions ?? this.instructions,
      collectorId: collectorId ?? this.collectorId,
      collectorName: collectorName ?? this.collectorName,
      collectorPhone: collectorPhone ?? this.collectorPhone,
      collectorRating: collectorRating ?? this.collectorRating,
      collectorDistance: collectorDistance ?? this.collectorDistance,
      otpCode: otpCode ?? this.otpCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
