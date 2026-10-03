import 'package:flutter_test/flutter_test.dart';
import 'package:e_kabaadi/services/reward_rules_service.dart';
import 'package:e_kabaadi/repositories/sweeper_repository.dart';
import 'package:e_kabaadi/models/cleaning_task_model.dart';

void main() {
  group('RewardRules — SWEEPER Eco Points (2 pts / Litre)', () {
    test('50 Litres cleaned → 100 Eco Points', () {
      expect(RewardRules.sweeperEcoPoints(50), 100);
    });

    test('80 Litres cleaned → 160 Eco Points', () {
      expect(RewardRules.sweeperEcoPoints(80), 160);
    });

    test('150 Litres cleaned → 300 Eco Points', () {
      expect(RewardRules.sweeperEcoPoints(150), 300);
    });

    test('0 or negative volume → 0 points', () {
      expect(RewardRules.sweeperEcoPoints(0), 0);
      expect(RewardRules.sweeperEcoPoints(-20), 0);
    });
  });

  group('RewardLedger — Sweeper Points Management', () {
    setUp(() {
      RewardLedger.reset(citizenPoints: 20, collectorCoins: 1215, sweeperPoints: 500);
    });

    test('initial sweeper balance is respected', () {
      expect(RewardLedger.sweeperPoints, 500);
    });

    test('awarding points for cleaned volume increases sweeper balance', () {
      final earned = RewardLedger.awardSweeperPointsForCleaning(100); // 100 * 2 = 200 pts
      expect(earned, 200);
      expect(RewardLedger.sweeperPoints, 700);
    });

    test('redeeming points reduces balance when sufficient', () {
      final success = RewardLedger.redeemSweeperPoints(200);
      expect(success, isTrue);
      expect(RewardLedger.sweeperPoints, 300);
    });

    test('redeeming points fails when balance is insufficient', () {
      final success = RewardLedger.redeemSweeperPoints(600);
      expect(success, isFalse);
      expect(RewardLedger.sweeperPoints, 500);
    });
  });

  group('MockSweeperRepository — Task Lifecycle', () {
    late MockSweeperRepository repo;

    setUp(() {
      repo = MockSweeperRepository();
    });

    test('loads nearby demo garbage spots', () async {
      final spots = await repo.getNearbyGarbageSpots(28.6250, 77.3680);
      expect(spots.isNotEmpty, isTrue);
      expect(spots.first.garbageType, isNotNull);
      expect(spots.first.rewardPoints, greaterThan(0));
    });

    test('claims task and advances lifecycle', () async {
      final spots = await repo.getNearbyGarbageSpots(28.6250, 77.3680);
      final spotId = spots.first.id;

      final task = await repo.claimTask(spotId, 'SWP-TEST-001');
      expect(task, isNotNull);
      expect(task!.status, CleaningTaskStatus.claimed);
      expect(task.garbageSpotId, spotId);

      // Start task
      final started = await repo.startTask(task.id);
      expect(started, isNotNull);
      expect(started!.status, CleaningTaskStatus.inProgress);

      // Submit before photo
      final before = await repo.submitBeforePhoto(task.id, 'path/to/before.jpg');
      expect(before, isNotNull);
      expect(before!.beforePhotoPath, 'path/to/before.jpg');

      // Submit after photo
      final after = await repo.submitAfterPhoto(task.id, 'path/to/after.jpg');
      expect(after, isNotNull);
      expect(after!.afterPhotoPath, 'path/to/after.jpg');

      // Submit completion volume
      final completed = await repo.submitCompletion(task.id, 120.0);
      expect(completed, isNotNull);
      expect(completed!.status, CleaningTaskStatus.verificationPending);
      expect(completed.reportedVolumeLitres, 120.0);

      // Approve task
      final approved = await repo.approveTask(task.id);
      expect(approved, isNotNull);
      expect(approved!.status, CleaningTaskStatus.completed);
      expect(approved.verifiedVolumeLitres, 120.0);
    });
  });
}
