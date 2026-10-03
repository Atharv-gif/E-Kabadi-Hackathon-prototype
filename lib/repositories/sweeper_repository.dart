import 'dart:math';
import '../models/garbage_spot_model.dart';
import '../models/cleaning_task_model.dart';

/// Configurable point rate for sweeper eco-point calculation.
/// Volume (litres) × this rate = Eco Points earned.
const double sweeperPointsPerLitre = 2.0;

abstract class SweeperRepository {
  Future<List<GarbageSpot>> getNearbyGarbageSpots(double lat, double lng);
  Future<GarbageSpot?> getGarbageSpotById(String id);
  Future<CleaningTask?> claimTask(String garbageSpotId, String sweeperId);
  Future<CleaningTask?> startTask(String taskId);
  Future<CleaningTask?> submitBeforePhoto(String taskId, String photoPath);
  Future<CleaningTask?> submitAfterPhoto(String taskId, String photoPath);
  Future<CleaningTask?> submitCompletion(String taskId, double volumeLitres);
  Future<CleaningTask?> approveTask(String taskId);
  Future<List<CleaningTask>> getTaskHistory(String sweeperId);
  Future<CleaningTask?> getActiveTask(String sweeperId);
}

class MockSweeperRepository implements SweeperRepository {
  // ── Demo garbage spots (prototype / hackathon data) ──
  // Coordinates are near the existing demo area (Sector 62, Noida).
  final List<GarbageSpot> _spots = [
    const GarbageSpot(
      id: 'GS-001',
      latitude: 28.6270,
      longitude: 77.3650,
      garbageType: GarbageType.mixed,
      size: GarbageSize.large,
      estimatedVolumeLitres: 150,
      description: 'Large roadside garbage accumulation near residential area.',
      rewardPoints: 300,
      createdAt: '01 Oct 2026',
    ),
    const GarbageSpot(
      id: 'GS-002',
      latitude: 28.6200,
      longitude: 77.3700,
      garbageType: GarbageType.plastic,
      size: GarbageSize.medium,
      estimatedVolumeLitres: 80,
      description: 'Plastic bottles and packaging waste near park entrance.',
      rewardPoints: 160,
      createdAt: '01 Oct 2026',
    ),
    const GarbageSpot(
      id: 'GS-003',
      latitude: 28.6310,
      longitude: 77.3580,
      garbageType: GarbageType.organic,
      size: GarbageSize.small,
      estimatedVolumeLitres: 40,
      description: 'Organic waste pile near community garden.',
      rewardPoints: 80,
      createdAt: '02 Oct 2026',
    ),
    const GarbageSpot(
      id: 'GS-004',
      latitude: 28.6150,
      longitude: 77.3620,
      garbageType: GarbageType.mixed,
      size: GarbageSize.veryLarge,
      estimatedVolumeLitres: 350,
      description: 'Construction and mixed waste dump site behind commercial complex.',
      rewardPoints: 500,
      createdAt: '30 Sep 2026',
    ),
    const GarbageSpot(
      id: 'GS-005',
      latitude: 28.6240,
      longitude: 77.3740,
      garbageType: GarbageType.plastic,
      size: GarbageSize.large,
      estimatedVolumeLitres: 200,
      description: 'Large plastic waste accumulation in vacant lot.',
      rewardPoints: 400,
      createdAt: '02 Oct 2026',
    ),
  ];

  // In-memory task storage
  final List<CleaningTask> _tasks = [];

  // Helper to compute simple demo distances
  double _distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const earthR = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLng / 2) * sin(dLng / 2);
    return earthR * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  @override
  Future<List<GarbageSpot>> getNearbyGarbageSpots(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Return only available spots, sorted by distance
    final available = _spots.where((s) => s.status == GarbageSpotStatus.available).toList();
    available.sort((a, b) {
      final distA = _distanceKm(lat, lng, a.latitude, a.longitude);
      final distB = _distanceKm(lat, lng, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });
    return available;
  }

  /// Compute distance for display purposes.
  double getDistanceKm(double lat, double lng, GarbageSpot spot) {
    return _distanceKm(lat, lng, spot.latitude, spot.longitude);
  }

  @override
  Future<GarbageSpot?> getGarbageSpotById(String id) async {
    try {
      return _spots.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CleaningTask?> claimTask(String garbageSpotId, String sweeperId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Check if the spot is still available
    final spotIndex = _spots.indexWhere((s) => s.id == garbageSpotId);
    if (spotIndex == -1) return null;
    if (_spots[spotIndex].status != GarbageSpotStatus.available) return null;

    // Mark the spot as claimed
    _spots[spotIndex] = _spots[spotIndex].copyWith(status: GarbageSpotStatus.claimed);

    final task = CleaningTask(
      id: 'CT-${DateTime.now().millisecondsSinceEpoch}',
      garbageSpotId: garbageSpotId,
      sweeperId: sweeperId,
      status: CleaningTaskStatus.claimed,
    );
    _tasks.add(task);
    return task;
  }

  @override
  Future<CleaningTask?> startTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return null;
    final updated = _tasks[idx].copyWith(
      status: CleaningTaskStatus.inProgress,
      startedAt: DateTime.now(),
    );
    _tasks[idx] = updated;
    return updated;
  }

  @override
  Future<CleaningTask?> submitBeforePhoto(String taskId, String photoPath) async {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return null;
    final updated = _tasks[idx].copyWith(beforePhotoPath: photoPath);
    _tasks[idx] = updated;
    return updated;
  }

  @override
  Future<CleaningTask?> submitAfterPhoto(String taskId, String photoPath) async {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return null;
    final updated = _tasks[idx].copyWith(afterPhotoPath: photoPath);
    _tasks[idx] = updated;
    return updated;
  }

  @override
  Future<CleaningTask?> submitCompletion(String taskId, double volumeLitres) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return null;

    final estimatedPoints = (volumeLitres * sweeperPointsPerLitre).round();
    final updated = _tasks[idx].copyWith(
      status: CleaningTaskStatus.verificationPending,
      reportedVolumeLitres: volumeLitres,
      ecoPointsAwarded: estimatedPoints,
      completedAt: DateTime.now(),
    );
    _tasks[idx] = updated;
    return updated;
  }

  @override
  Future<CleaningTask?> approveTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx == -1) return null;

    final task = _tasks[idx];
    final verifiedVolume = task.reportedVolumeLitres ?? 0;
    final earnedPoints = (verifiedVolume * sweeperPointsPerLitre).round();

    final updated = task.copyWith(
      status: CleaningTaskStatus.completed,
      verifiedVolumeLitres: verifiedVolume,
      ecoPointsAwarded: earnedPoints,
    );
    _tasks[idx] = updated;

    // Mark the garbage spot as completed
    final spotIdx = _spots.indexWhere((s) => s.id == task.garbageSpotId);
    if (spotIdx != -1) {
      _spots[spotIdx] = _spots[spotIdx].copyWith(status: GarbageSpotStatus.completed);
    }

    return updated;
  }

  @override
  Future<List<CleaningTask>> getTaskHistory(String sweeperId) async {
    return _tasks.where((t) => t.sweeperId == sweeperId).toList();
  }

  @override
  Future<CleaningTask?> getActiveTask(String sweeperId) async {
    try {
      return _tasks.firstWhere(
        (t) =>
            t.sweeperId == sweeperId &&
            t.status != CleaningTaskStatus.completed &&
            t.status != CleaningTaskStatus.cancelled &&
            t.status != CleaningTaskStatus.rejected,
      );
    } catch (_) {
      return null;
    }
  }
}
