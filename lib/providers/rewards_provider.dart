import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/eco_point_model.dart';
import '../models/eco_coin_model.dart';
import '../models/recycling_journey_model.dart';
import '../repositories/rewards_repository.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  return MockRewardsRepository();
});

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

final recyclingJourneysProvider = FutureProvider<List<RecyclingJourneyModel>>((ref) {
  final repo = ref.watch(rewardsRepositoryProvider);
  return repo.getRecyclingJourneys();
});
