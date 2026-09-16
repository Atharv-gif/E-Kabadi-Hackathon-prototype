class JourneyStep {
  final String title;
  final String description;
  final String location;
  final String timestamp;
  final bool isCompleted;

  const JourneyStep({
    required this.title,
    required this.description,
    required this.location,
    required this.timestamp,
    required this.isCompleted,
  });
}

class RecyclingJourneyModel {
  final String id;
  final String pickupId;
  final String materialCategory;
  final double weightKg;
  final String citizenName;
  final String collectorName;
  final String recyclerFacility;
  final String certificateId;
  final List<JourneyStep> steps;

  const RecyclingJourneyModel({
    required this.id,
    required this.pickupId,
    required this.materialCategory,
    required this.weightKg,
    required this.citizenName,
    required this.collectorName,
    required this.recyclerFacility,
    required this.certificateId,
    required this.steps,
  });
}
