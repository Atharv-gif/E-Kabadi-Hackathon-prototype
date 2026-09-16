import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pickup_request_model.dart';
import '../repositories/pickup_repository.dart';
import 'pickup_provider.dart';

class CollectorState {
  final bool isAvailable;
  final List<PickupRequestModel> nearbyRequests;
  final PickupRequestModel? currentAssignedPickup;
  final double todayEarnings;
  final int todayPickupsCount;
  final double todayWeightKg;
  final bool isLoading;

  const CollectorState({
    this.isAvailable = true,
    this.nearbyRequests = const [],
    this.currentAssignedPickup,
    this.todayEarnings = 2450.0,
    this.todayPickupsCount = 7,
    this.todayWeightKg = 38.5,
    this.isLoading = false,
  });

  CollectorState copyWith({
    bool? isAvailable,
    List<PickupRequestModel>? nearbyRequests,
    PickupRequestModel? currentAssignedPickup,
    double? todayEarnings,
    int? todayPickupsCount,
    double? todayWeightKg,
    bool? isLoading,
  }) {
    return CollectorState(
      isAvailable: isAvailable ?? this.isAvailable,
      nearbyRequests: nearbyRequests ?? this.nearbyRequests,
      currentAssignedPickup: currentAssignedPickup ?? this.currentAssignedPickup,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      todayPickupsCount: todayPickupsCount ?? this.todayPickupsCount,
      todayWeightKg: todayWeightKg ?? this.todayWeightKg,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CollectorNotifier extends StateNotifier<CollectorState> {
  final PickupRepository _repository;

  CollectorNotifier(this._repository) : super(const CollectorState()) {
    loadNearbyRequests();
  }

  Future<void> loadNearbyRequests() async {
    state = state.copyWith(isLoading: true);
    final requests = await _repository.getNearbyCollectorRequests();
    state = state.copyWith(isLoading: false, nearbyRequests: requests);
  }

  void toggleAvailability(bool val) {
    state = state.copyWith(isAvailable: val);
  }

  void acceptRequest(PickupRequestModel request) {
    final updated = request.copyWith(status: PickupStatus.onTheWay);
    state = state.copyWith(
      currentAssignedPickup: updated,
      nearbyRequests: state.nearbyRequests.where((r) => r.id != request.id).toList(),
    );
  }

  void updateCollectorPickupStatus(PickupStatus status) {
    if (state.currentAssignedPickup != null) {
      final updated = state.currentAssignedPickup!.copyWith(status: status);
      state = state.copyWith(currentAssignedPickup: updated);
    }
  }

  void completeCollection(double weight, double amount) {
    if (state.currentAssignedPickup != null) {
      state = state.copyWith(
        todayEarnings: state.todayEarnings + amount,
        todayPickupsCount: state.todayPickupsCount + 1,
        todayWeightKg: state.todayWeightKg + weight,
        currentAssignedPickup: null,
      );
    }
  }
}

final collectorProvider = StateNotifierProvider<CollectorNotifier, CollectorState>((ref) {
  final repo = ref.watch(pickupRepositoryProvider);
  return CollectorNotifier(repo);
});
