import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pickup_request_model.dart';
import '../models/scrap_item_model.dart';
import '../models/payment_model.dart';
import '../repositories/pickup_repository.dart';
import '../repositories/payment_repository.dart';

final pickupRepositoryProvider = Provider<PickupRepository>((ref) {
  return MockPickupRepository();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return MockPaymentRepository();
});

class PickupState {
  final bool isLoading;
  final PickupRequestModel? activePickup;
  final List<PickupRequestModel> allPickups;
  final PaymentModel? lastPayment;
  final String? error;
  final bool isMatchingCollector;

  const PickupState({
    this.isLoading = false,
    this.activePickup,
    this.allPickups = const [],
    this.lastPayment,
    this.error,
    this.isMatchingCollector = false,
  });

  PickupState copyWith({
    bool? isLoading,
    PickupRequestModel? activePickup,
    List<PickupRequestModel>? allPickups,
    PaymentModel? lastPayment,
    String? error,
    bool? isMatchingCollector,
  }) {
    return PickupState(
      isLoading: isLoading ?? this.isLoading,
      activePickup: activePickup ?? this.activePickup,
      allPickups: allPickups ?? this.allPickups,
      lastPayment: lastPayment ?? this.lastPayment,
      error: error,
      isMatchingCollector: isMatchingCollector ?? this.isMatchingCollector,
    );
  }
}

class PickupNotifier extends StateNotifier<PickupState> {
  final PickupRepository _pickupRepo;
  final PaymentRepository _paymentRepo;

  PickupNotifier(this._pickupRepo, this._paymentRepo) : super(const PickupState()) {
    loadPickups();
  }

  Future<void> loadPickups() async {
    state = state.copyWith(isLoading: true);
    try {
      final list = await _pickupRepo.getCitizenPickups();
      final active = await _pickupRepo.getActivePickup();
      state = state.copyWith(isLoading: false, allPickups: list, activePickup: active);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<PickupRequestModel> createRequest({
    required List<ScrapItemModel> items,
    required String date,
    required String timeSlot,
    required String address,
    required String instructions,
  }) async {
    state = state.copyWith(isMatchingCollector: true);
    await Future.delayed(const Duration(seconds: 2)); // Radar animation time

    final pickup = await _pickupRepo.createPickupRequest(
      items: items,
      scheduledDate: date,
      timeSlot: timeSlot,
      address: address,
      instructions: instructions,
    );

    // Auto assign mock collector for instant live tracking demo
    final assigned = pickup.copyWith(status: PickupStatus.onTheWay);
    
    state = state.copyWith(
      isMatchingCollector: false,
      activePickup: assigned,
    );

    await loadPickups();
    return assigned;
  }

  Future<void> updateStatus(PickupStatus newStatus) async {
    if (state.activePickup != null) {
      final updated = await _pickupRepo.updatePickupStatus(state.activePickup!.id, newStatus);
      state = state.copyWith(activePickup: updated);
      await loadPickups();
    }
  }

  Future<void> completePickupAndPay(double finalWeight, double finalAmount) async {
    if (state.activePickup != null) {
      final completed = await _pickupRepo.verifyAndCompletePickup(
        state.activePickup!.id,
        finalWeight,
        finalAmount,
      );

      final payment = PaymentModel(
        id: 'PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        pickupId: completed.id,
        amount: finalAmount,
        method: 'UPI / GPay Direct',
        status: 'SUCCESS',
        transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        timestamp: 'Just Now',
        ecoPointsEarned: 20,
      );

      await _paymentRepo.recordPayment(payment);

      state = state.copyWith(
        activePickup: completed,
        lastPayment: payment,
      );
      await loadPickups();
    }
  }
}

final pickupProvider = StateNotifierProvider<PickupNotifier, PickupState>((ref) {
  final pickupRepo = ref.watch(pickupRepositoryProvider);
  final paymentRepo = ref.watch(paymentRepositoryProvider);
  return PickupNotifier(pickupRepo, paymentRepo);
});
