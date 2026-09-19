/// Central, single source of truth for reward calculation rules.
///
/// CITIZEN — "Eco Points":
///   * Earned ONLY when the FINAL VERIFIED scrap bill is ₹500 or more.
///   * Below ₹500 → 0 points (no partial rewards).
///   * At or above ₹500 → 10% of the final bill amount.
///   * The ₹500 threshold applies to citizens ONLY.
///
/// COLLECTOR — "Eco Coins":
///   * Earned on EVERY completed transaction — no threshold.
///   * Always 10% of the transaction amount.
///
/// Both are always calculated from the FINAL VERIFIED bill amount —
/// never from approximate weight or AI estimated values.
class RewardRules {
  RewardRules._();

  /// Minimum final verified bill (₹) for a citizen to earn Eco Points.
  static const double citizenMinBillForPoints = 500.0;

  /// Reward rate applied to the final verified bill (10%).
  static const double rewardRate = 0.10;

  /// Returns true when a citizen qualifies for Eco Points for [finalBillAmount].
  static bool isCitizenEligible(double finalBillAmount) {
    return finalBillAmount >= citizenMinBillForPoints;
  }

  /// Eco Points for a citizen from the FINAL VERIFIED bill.
  /// ₹400/₹499 → 0 · ₹500 → 50 · ₹800 → 80 · ₹1,200 → 120.
  static int citizenEcoPoints(double finalBillAmount) {
    if (!isCitizenEligible(finalBillAmount)) return 0;
    return (finalBillAmount * rewardRate).floor();
  }

  /// Eco Coins for a collector on EVERY completed transaction — no threshold.
  /// ₹200 → 20 · ₹450 → 45 · ₹1,000 → 100.
  static int collectorEcoCoins(double transactionAmount) {
    if (transactionAmount <= 0) return 0;
    return (transactionAmount * rewardRate).floor();
  }

  /// Bill amount still required for a citizen to become eligible.
  /// Returns 0 when already eligible.
  static double citizenAmountToThreshold(double finalBillAmount) {
    final remaining = citizenMinBillForPoints - finalBillAmount;
    return remaining > 0 ? remaining : 0;
  }
}

/// Lightweight in-memory ledger of reward transactions.
///
/// The mock repositories act as the data source of truth for this demo build;
/// when a real backend is wired in, this ledger should be replaced by API
/// calls without changing [RewardRules] or the UI layer.
class RewardLedger {
  RewardLedger._();

  // Demo balances kept consistent with the mock reward history:
  // citizen +120 earned (₹1,200 bill) − 100 redeemed = 20.
  static int _citizenPoints = 20;
  static int _collectorCoins = 1215;

  static final List<void Function()> _listeners = [];

  static int get citizenPoints => _citizenPoints;
  static int get collectorCoins => _collectorCoins;

  static void addListener(void Function() listener) => _listeners.add(listener);

  static void removeListener(void Function() listener) =>
      _listeners.remove(listener);

  static void _notify() {
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }

  /// Awards citizen Eco Points derived from the FINAL VERIFIED bill.
  /// Returns the number of points actually awarded (0 when below ₹500).
  static int awardCitizenPointsForBill(double finalBillAmount) {
    final earned = RewardRules.citizenEcoPoints(finalBillAmount);
    if (earned > 0) {
      _citizenPoints += earned;
      _notify();
    }
    return earned;
  }

  /// Awards collector Eco Coins derived from the FINAL VERIFIED transaction
  /// amount. No threshold — every completed transaction earns coins.
  static int awardCollectorCoinsForTransaction(double transactionAmount) {
    final earned = RewardRules.collectorEcoCoins(transactionAmount);
    if (earned > 0) {
      _collectorCoins += earned;
      _notify();
    }
    return earned;
  }

  /// Attempts to redeem [cost] points. Returns false when balance is
  /// insufficient — the UI must keep the Redeem action disabled in that case.
  static bool redeemCitizenPoints(int cost) {
    if (cost > _citizenPoints) return false;
    _citizenPoints -= cost;
    _notify();
    return true;
  }

  /// Attempts to redeem [cost] coins for collector benefits.
  static bool redeemCollectorCoins(int cost) {
    if (cost > _collectorCoins) return false;
    _collectorCoins -= cost;
    _notify();
    return true;
  }

  /// Testing / demo reset.
  static void reset({int citizenPoints = 20, int collectorCoins = 1215}) {
    _citizenPoints = citizenPoints;
    _collectorCoins = collectorCoins;
    _notify();
  }
}
