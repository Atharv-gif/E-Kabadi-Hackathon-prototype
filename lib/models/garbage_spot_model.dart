/// Garbage type categories for cleaning tasks.
enum GarbageType { mixed, plastic, organic, construction, eWaste }

/// Size classification used for quick volume estimation.
enum GarbageSize { small, medium, large, veryLarge }

/// Current lifecycle status of a garbage spot.
enum GarbageSpotStatus { reported, verified, available, claimed, completed }

class GarbageSpot {
  final String id;
  final double latitude;
  final double longitude;
  final GarbageType garbageType;
  final GarbageSize size;
  final int estimatedVolumeLitres;
  final String? imageUrl;
  final String description;
  final GarbageSpotStatus status;
  final int rewardPoints;
  final String createdAt;

  const GarbageSpot({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.garbageType,
    required this.size,
    required this.estimatedVolumeLitres,
    this.imageUrl,
    required this.description,
    this.status = GarbageSpotStatus.available,
    required this.rewardPoints,
    required this.createdAt,
  });

  GarbageSpot copyWith({
    GarbageSpotStatus? status,
  }) {
    return GarbageSpot(
      id: id,
      latitude: latitude,
      longitude: longitude,
      garbageType: garbageType,
      size: size,
      estimatedVolumeLitres: estimatedVolumeLitres,
      imageUrl: imageUrl,
      description: description,
      status: status ?? this.status,
      rewardPoints: rewardPoints,
      createdAt: createdAt,
    );
  }

  /// Human-readable garbage type label.
  String get garbageTypeLabel {
    switch (garbageType) {
      case GarbageType.mixed:
        return 'Mixed Waste';
      case GarbageType.plastic:
        return 'Plastic Waste';
      case GarbageType.organic:
        return 'Organic Waste';
      case GarbageType.construction:
        return 'Construction Debris';
      case GarbageType.eWaste:
        return 'E-Waste';
    }
  }

  /// Human-readable size label.
  String get sizeLabel {
    switch (size) {
      case GarbageSize.small:
        return 'Small (0–50 L)';
      case GarbageSize.medium:
        return 'Medium (51–150 L)';
      case GarbageSize.large:
        return 'Large (151–300 L)';
      case GarbageSize.veryLarge:
        return 'Very Large (300+ L)';
    }
  }

  String get typeDisplayName => garbageTypeLabel;
}
