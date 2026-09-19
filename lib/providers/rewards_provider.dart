import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/eco_point_model.dart';
import '../models/eco_coin_model.dart';
import '../models/recycling_journey_model.dart';
import '../repositories/rewards_repository.dart';
import '../services/reward_rules_service.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  return MockRewardsRepository();
});

/// Reactive Eco Points balance for the CITIZEN side.
/// "Eco Points" are citizen-only; collectors use "Eco Coins".
final citizenEcoPointsProvider =
    StateNotifierProvider<CitizenEcoPointsNotifier, int>((ref) {
  return CitizenEcoPointsNotifier();
});

class CitizenEcoPointsNotifier extends StateNotifier<int> {
  CitizenEcoPointsNotifier() : super(RewardLedger.citizenPoints) {
    RewardLedger.addListener(_sync);
  }

  void _sync() {
    if (mounted) state = RewardLedger.citizenPoints;
  }

  /// Awards Eco Points from the FINAL VERIFIED bill.
  /// Applies the ₹500 citizen threshold internally — 0 points below ₹500.
  int awardForFinalBill(double finalBillAmount) {
    return RewardLedger.awardCitizenPointsForBill(finalBillAmount);
  }

  /// Redeem is only possible with a sufficient balance; returns false when
  /// the citizen cannot afford [cost], and the UI must show a disabled state.
  bool redeem(int cost) => RewardLedger.redeemCitizenPoints(cost);

  @override
  void dispose() {
    RewardLedger.removeListener(_sync);
    super.dispose();
  }
}

/// Reactive Eco Coins balance for the COLLECTOR side.
/// Collectors earn on EVERY completed transaction — no ₹500 threshold.
final collectorEcoCoinsProvider =
    StateNotifierProvider<CollectorEcoCoinsNotifier, int>((ref) {
  return CollectorEcoCoinsNotifier();
});

class CollectorEcoCoinsNotifier extends StateNotifier<int> {
  CollectorEcoCoinsNotifier() : super(RewardLedger.collectorCoins) {
    RewardLedger.addListener(_sync);
  }

  void _sync() {
    if (mounted) state = RewardLedger.collectorCoins;
  }

  /// Awards coins from the FINAL VERIFIED transaction amount.
  /// No threshold — every completed transaction earns 10%.
  int awardForFinalTransaction(double finalTransactionAmount) {
    return RewardLedger.awardCollectorCoinsForTransaction(finalTransactionAmount);
  }

  bool redeem(int cost) => RewardLedger.redeemCollectorCoins(cost);

  @override
  void dispose() {
    RewardLedger.removeListener(_sync);
    super.dispose();
  }
}

final citizenPointHistoryProvider = FutureProvider<List<EcoPointModel>>((ref) {
  final repo = ref.watch(rewardsRepositoryProvider);
  return repo.getCitizenPointHistory();
});

final collectorCoinHistoryProvider = FutureProvider<List<EcoCoinModel>>((ref) {
  final repo = ref.watch(rewardsRepositoryProvider);
  return repo.getCollectorCoinHistory();
});

final availableCouponsProvider = FutureProvider<List<RewardCoupon>>((ref) {
  final repo = ref.watch(rewardsRepositoryProvider);
  return repo.getAvailableCoupons();
});

final recyclingJourneysProvider =
    FutureProvider<List<RecyclingJourneyModel>>((ref) {
  final repo = ref.watch(rewardsRepositoryProvider);
  return repo.getRecyclingJourneys();
});
