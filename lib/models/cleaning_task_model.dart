/// Task lifecycle states — kept deliberately simple for the hackathon.
enum CleaningTaskStatus {
  available,
  claimed,
  inProgress,
  submitted,
  verificationPending,
  completed,
  cancelled,
  rejected,
}

class CleaningTask {
  final String id;
  final String garbageSpotId;
  final String? sweeperId;
  final CleaningTaskStatus status;
  final String? beforePhotoPath;
  final String? afterPhotoPath;
  final double? reportedVolumeLitres;
  final double? verifiedVolumeLitres;
  final int ecoPointsAwarded;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? startLatitude;
  final double? startLongitude;
  final double? completionLatitude;
  final double? completionLongitude;

  const CleaningTask({
    required this.id,
    required this.garbageSpotId,
    this.sweeperId,
    this.status = CleaningTaskStatus.available,
    this.beforePhotoPath,
    this.afterPhotoPath,
    this.reportedVolumeLitres,
    this.verifiedVolumeLitres,
    this.ecoPointsAwarded = 0,
    this.startedAt,
    this.completedAt,
    this.startLatitude,
    this.startLongitude,
    this.completionLatitude,
    this.completionLongitude,
  });

  CleaningTask copyWith({
    String? sweeperId,
    CleaningTaskStatus? status,
    String? beforePhotoPath,
    String? afterPhotoPath,
    double? reportedVolumeLitres,
    double? verifiedVolumeLitres,
    int? ecoPointsAwarded,
    DateTime? startedAt,
    DateTime? completedAt,
    double? startLatitude,
    double? startLongitude,
    double? completionLatitude,
    double? completionLongitude,
  }) {
    return CleaningTask(
      id: id,
      garbageSpotId: garbageSpotId,
      sweeperId: sweeperId ?? this.sweeperId,
      status: status ?? this.status,
      beforePhotoPath: beforePhotoPath ?? this.beforePhotoPath,
      afterPhotoPath: afterPhotoPath ?? this.afterPhotoPath,
      reportedVolumeLitres: reportedVolumeLitres ?? this.reportedVolumeLitres,
      verifiedVolumeLitres: verifiedVolumeLitres ?? this.verifiedVolumeLitres,
      ecoPointsAwarded: ecoPointsAwarded ?? this.ecoPointsAwarded,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      completionLatitude: completionLatitude ?? this.completionLatitude,
      completionLongitude: completionLongitude ?? this.completionLongitude,
    );
  }

  /// Human-readable status label.
  String get statusLabel {
    switch (status) {
      case CleaningTaskStatus.available:
        return 'Available';
      case CleaningTaskStatus.claimed:
        return 'Claimed';
      case CleaningTaskStatus.inProgress:
        return 'In Progress';
      case CleaningTaskStatus.submitted:
        return 'Submitted';
      case CleaningTaskStatus.verificationPending:
        return 'Verification Pending';
      case CleaningTaskStatus.completed:
        return 'Completed';
      case CleaningTaskStatus.cancelled:
        return 'Cancelled';
      case CleaningTaskStatus.rejected:
        return 'Rejected';
    }
  }

  String? get beforePhotoUrl => beforePhotoPath;
  String? get afterPhotoUrl => afterPhotoPath;
  double get estimatedVolumeLitres => reportedVolumeLitres ?? verifiedVolumeLitres ?? 100.0;
  String get claimedAt => startedAt?.toIso8601String() ?? 'Recent';
}
