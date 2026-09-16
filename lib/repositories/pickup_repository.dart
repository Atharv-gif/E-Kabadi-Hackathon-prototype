import '../models/pickup_request_model.dart';
import '../models/scrap_item_model.dart';

abstract class PickupRepository {
  Future<PickupRequestModel> createPickupRequest({
    required List<ScrapItemModel> items,
    required String scheduledDate,
    required String timeSlot,
    required String address,
    required String instructions,
  });

  Future<List<PickupRequestModel>> getCitizenPickups();
  Future<List<PickupRequestModel>> getNearbyCollectorRequests();
  Future<PickupRequestModel> updatePickupStatus(String pickupId, PickupStatus status);
  Future<PickupRequestModel> verifyAndCompletePickup(String pickupId, double finalWeight, double finalAmount);
  Future<PickupRequestModel?> getActivePickup();
}

class MockPickupRepository implements PickupRepository {
  final List<PickupRequestModel> _pickups = [
    PickupRequestModel(
      id: 'PK-9481',
      citizenId: 'USR-7890',
      citizenName: 'Aarav Sharma',
      citizenAddress: 'Flat 402, Green Valley Apts, Sector 62, Noida',
      citizenPhone: '+91 98765 12345',
      items: const [
        ScrapItemModel(
          id: 'SC-1',
          category: 'Plastic',
          subType: 'PET Bottles',
          weightKg: 1.4,
          pricePerKg: 50.0,
          estimatedTotal: 70.0,
          confidenceScore: 0.94,
        ),
        ScrapItemModel(
          id: 'SC-2',
          category: 'Paper & Cardboard',
          subType: 'Corrugated Boxes',
          weightKg: 3.2,
          pricePerKg: 15.0,
          estimatedTotal: 48.0,
          confidenceScore: 0.91,
        ),
      ],
      status: PickupStatus.onTheWay,
      totalEstimatedPrice: 118.0,
      finalVerifiedPrice: 118.0,
      scheduledDate: 'Today, 18 Sep',
      timeSlot: '11 AM - 1 PM',
      instructions: 'Ring bell twice upon arrival',
      collectorId: 'COL-892',
      collectorName: 'Ramesh Kumar',
      collectorPhone: '+91 98765 43210',
      collectorRating: 4.8,
      collectorDistance: '1.2 km away',
      otpCode: '4829',
      createdAt: '10:15 AM',
    ),
    const PickupRequestModel(
      id: 'PK-8320',
      citizenId: 'USR-7890',
      citizenName: 'Aarav Sharma',
      citizenAddress: 'Flat 402, Green Valley Apts, Sector 62, Noida',
      citizenPhone: '+91 98765 12345',
      items: [
        ScrapItemModel(
          id: 'SC-3',
          category: 'E-Waste',
          subType: 'Old Smartphone & Charger',
          weightKg: 0.4,
          pricePerKg: 850.0,
          estimatedTotal: 850.0,
          confidenceScore: 0.96,
        ),
      ],
      status: PickupStatus.completed,
      totalEstimatedPrice: 850.0,
      finalVerifiedPrice: 850.0,
      finalVerifiedWeight: 0.4,
      scheduledDate: '15 Sep 2026',
      timeSlot: '2 PM - 4 PM',
      collectorId: 'COL-892',
      collectorName: 'Ramesh Kumar',
      collectorPhone: '+91 98765 43210',
      collectorRating: 4.8,
      collectorDistance: 'Completed',
      otpCode: '1942',
      createdAt: '15 Sep, 01:30 PM',
    ),
  ];

  @override
  Future<PickupRequestModel> createPickupRequest({
    required List<ScrapItemModel> items,
    required String scheduledDate,
    required String timeSlot,
    required String address,
    required String instructions,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final total = items.fold(0.0, (sum, item) => sum + item.estimatedTotal);
    final newPickup = PickupRequestModel(
      id: 'PK-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      citizenId: 'USR-7890',
      citizenName: 'Aarav Sharma',
      citizenAddress: address,
      citizenPhone: '+91 98765 12345',
      items: items,
      status: PickupStatus.pending,
      totalEstimatedPrice: total,
      scheduledDate: scheduledDate,
      timeSlot: timeSlot,
      instructions: instructions,
      otpCode: '${(1000 + (DateTime.now().millisecondsSinceEpoch % 8999))}',
      createdAt: 'Just now',
    );

    _pickups.insert(0, newPickup);
    return newPickup;
  }

  @override
  Future<List<PickupRequestModel>> getCitizenPickups() async {
    return _pickups;
  }

  @override
  Future<List<PickupRequestModel>> getNearbyCollectorRequests() async {
    return _pickups.where((p) => p.status == PickupStatus.pending || p.status == PickupStatus.accepted || p.status == PickupStatus.onTheWay).toList();
  }

  @override
  Future<PickupRequestModel> updatePickupStatus(String pickupId, PickupStatus status) async {
    final index = _pickups.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickups[index] = _pickups[index].copyWith(status: status);
      return _pickups[index];
    }
    throw Exception('Pickup request not found');
  }

  @override
  Future<PickupRequestModel> verifyAndCompletePickup(String pickupId, double finalWeight, double finalAmount) async {
    final index = _pickups.indexWhere((p) => p.id == pickupId);
    if (index != -1) {
      _pickups[index] = _pickups[index].copyWith(
        status: PickupStatus.completed,
        finalVerifiedWeight: finalWeight,
        finalVerifiedPrice: finalAmount,
      );
      return _pickups[index];
    }
    throw Exception('Pickup request not found');
  }

  @override
  Future<PickupRequestModel?> getActivePickup() async {
    try {
      return _pickups.firstWhere((p) => p.status != PickupStatus.completed && p.status != PickupStatus.cancelled);
    } catch (_) {
      return null;
    }
  }
}
