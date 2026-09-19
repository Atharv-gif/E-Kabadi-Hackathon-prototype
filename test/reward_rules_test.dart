import 'package:flutter_test/flutter_test.dart';
import 'package:e_kabaadi/services/reward_rules_service.dart';

void main() {
  group('RewardRules — CITIZEN Eco Points (₹500 threshold, 10%)', () {
    test('₹400 bill → 0 points, not eligible', () {
      expect(RewardRules.isCitizenEligible(400), isFalse);
      expect(RewardRules.citizenEcoPoints(400), 0);
    });

    test('₹499 bill → 0 points, not eligible', () {
      expect(RewardRules.isCitizenEligible(499), isFalse);
      expect(RewardRules.citizenEcoPoints(499), 0);
    });

    test('₹500 bill → 50 points, eligible', () {
      expect(RewardRules.isCitizenEligible(500), isTrue);
      expect(RewardRules.citizenEcoPoints(500), 50);
    });

    test('₹800 bill → 80 points, eligible', () {
      expect(RewardRules.citizenEcoPoints(800), 80);
    });

    test('₹1,000 bill → 100 points, eligible', () {
      expect(RewardRules.citizenEcoPoints(1000), 100);
    });

    test('₹1,200 bill → 120 points, eligible', () {
      expect(RewardRules.citizenEcoPoints(1200), 120);
    });

    test('negative or zero bills → 0 points', () {
      expect(RewardRules.citizenEcoPoints(0), 0);
      expect(RewardRules.citizenEcoPoints(-100), 0);
    });

    test('amount to threshold', () {
      expect(RewardRules.citizenAmountToThreshold(400), 100);
      expect(RewardRules.citizenAmountToThreshold(499), 1);
      expect(RewardRules.citizenAmountToThreshold(500), 0);
      expect(RewardRules.citizenAmountToThreshold(1200), 0);
    });
  });

  group('RewardRules — COLLECTOR Eco Coins (10%, NO threshold)', () {
    test('₹200 transaction → 20 coins (no threshold)', () {
      expect(RewardRules.collectorEcoCoins(200), 20);
    });

    test('₹450 transaction → 45 coins (no threshold)', () {
      expect(RewardRules.collectorEcoCoins(450), 45);
    });

    test('₹500 transaction → 50 coins', () {
      expect(RewardRules.collectorEcoCoins(500), 50);
    });

    test('₹1,000 transaction → 100 coins', () {
      expect(RewardRules.collectorEcoCoins(1000), 100);
    });

    test('small transactions still earn — NO ₹500 threshold', () {
      expect(RewardRules.collectorEcoCoins(50), 5);
      expect(RewardRules.collectorEcoCoins(100), 10);
    });

    test('zero or negative → 0 coins', () {
      expect(RewardRules.collectorEcoCoins(0), 0);
      expect(RewardRules.collectorEcoCoins(-200), 0);
    });
  });

  group('RewardLedger', () {
    setUp(() {
      RewardLedger.reset(citizenPoints: 20, collectorCoins: 1215);
    });

    test('citizen earns nothing below ₹500', () {
      final earned = RewardLedger.awardCitizenPointsForBill(430);
      expect(earned, 0);
      expect(RewardLedger.citizenPoints, 20);
    });

    test('citizen earns 10% at ₹500+', () {
      final earned = RewardLedger.awardCitizenPointsForBill(1200);
      expect(earned, 120);
      expect(RewardLedger.citizenPoints, 140);
    });

    test('collector earns on every transaction regardless of amount', () {
      final earned = RewardLedger.awardCollectorCoinsForTransaction(200);
      expect(earned, 20);
      expect(RewardLedger.collectorCoins, 1235);
    });

    test('redeem fails when balance insufficient', () {
      expect(RewardLedger.redeemCitizenPoints(500), isFalse);
      expect(RewardLedger.citizenPoints, 20);
      expect(RewardLedger.redeemCitizenPoints(20), isTrue);
      expect(RewardLedger.citizenPoints, 0);
    });

    test('collector redeem fails when balance insufficient', () {
      expect(RewardLedger.redeemCollectorCoins(2000), isFalse);
      expect(RewardLedger.collectorCoins, 1215);
      expect(RewardLedger.redeemCollectorCoins(300), isTrue);
      expect(RewardLedger.collectorCoins, 915);
    });

    test('notifies listeners on balance changes', () {
      var notified = 0;
      void listener() => notified++;
      RewardLedger.addListener(listener);
      RewardLedger.awardCollectorCoinsForTransaction(1000); // +100 coins
      RewardLedger.redeemCitizenPoints(20); // affordable → balance change
      expect(notified, 2);
      // Unaffordable redemption must NOT change state or notify.
      RewardLedger.redeemCollectorCoins(99999);
      expect(notified, 2);
      RewardLedger.removeListener(listener);
    });
  });
}
