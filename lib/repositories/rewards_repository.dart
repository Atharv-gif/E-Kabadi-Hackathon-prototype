import '../models/eco_point_model.dart';
import '../models/eco_coin_model.dart';
import '../models/recycling_journey_model.dart';

class RewardCoupon {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final String partnerName;
  final String couponCode;
  final String expiryDate;

  const RewardCoupon({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.partnerName,
    required this.couponCode,
    required this.expiryDate,
  });
}

abstract class RewardsRepository {
  Future<List<EcoPointModel>> getCitizenPointHistory();
  Future<List<EcoCoinModel>> getCollectorCoinHistory();
  Future<List<RewardCoupon>> getAvailableCoupons();
  Future<List<RecyclingJourneyModel>> getRecyclingJourneys();
}

class MockRewardsRepository implements RewardsRepository {
  @override
  Future<List<EcoPointModel>> getCitizenPointHistory() async {
    return const [
      EcoPointModel(
        id: 'PT-101',
        points: 20,
        type: 'earned',
        title: 'Pickup Completed',
        description: 'Recycled 4.6 kg mixed plastic & paper',
        timestamp: '18 Sep 2026',
      ),
      EcoPointModel(
        id: 'PT-102',
        points: 170,
        type: 'earned',
        title: 'E-Waste Recycling Bonus',
        description: 'Recycled smartphone & charger',
        timestamp: '15 Sep 2026',
      ),
      EcoPointModel(
        id: 'PT-103',
        points: 100,
        type: 'redeemed',
        title: '₹50 Groceries Voucher',
        description: 'Redeemed at SuperEco Market',
        timestamp: '10 Sep 2026',
      ),
    ];
  }

  @override
  Future<List<EcoCoinModel>> getCollectorCoinHistory() async {
    return const [
      EcoCoinModel(
        id: 'CN-201',
        coins: 150,
        title: 'Pickup Milestone Completed',
        description: 'Completed 5 pickups in a day',
        category: 'Bonus',
        isCredit: true,
        timestamp: '18 Sep 2026',
      ),
      EcoCoinModel(
        id: 'CN-202',
        coins: 50,
        title: 'Prompt Arrival Bonus',
        description: 'Arrived within ETA window',
        category: 'Performance',
        isCredit: true,
        timestamp: '17 Sep 2026',
      ),
      EcoCoinModel(
        id: 'CN-203',
        coins: 500,
        title: 'Monthly Ration Voucher Redeemed',
        description: '10kg Rice & Atta Ration Kit',
        category: 'Ration',
        isCredit: false,
        timestamp: '01 Sep 2026',
      ),
    ];
  }

  @override
  Future<List<RewardCoupon>> getAvailableCoupons() async {
    return const [
      RewardCoupon(
        id: 'CP-1',
        title: '₹50 Flat Cashback',
        description: 'Direct UPI transfer to your bank account.',
        pointsCost: 500,
        partnerName: 'E-Kabaadi Direct',
        couponCode: 'EKAB50CASH',
        expiryDate: '31 Oct 2026',
      ),
      RewardCoupon(
        id: 'CP-2',
        title: '15% Off Green Groceries',
        description: 'Valid on organic vegetables & fruits.',
        pointsCost: 350,
        partnerName: 'Organic Bazaar',
        couponCode: 'GREEN15',
        expiryDate: '15 Nov 2026',
      ),
      RewardCoupon(
        id: 'CP-3',
        title: 'Free Solar Lamp Kit',
        description: 'Rechargeable eco solar light for home.',
        pointsCost: 1200,
        partnerName: 'CleanEnergy India',
        couponCode: 'SOLARFREE',
        expiryDate: '31 Dec 2026',
      ),
    ];
  }

  @override
  Future<List<RecyclingJourneyModel>> getRecyclingJourneys() async {
    return const [
      RecyclingJourneyModel(
        id: 'JRN-4819',
        pickupId: 'PK-9481',
        materialCategory: 'Plastic (PET) & Paper',
        weightKg: 4.6,
        citizenName: 'Aarav Sharma',
        collectorName: 'Ramesh Kumar',
        recyclerFacility: 'GreenLoop Authorized Recycling Plant #4, Greater Noida',
        certificateId: 'CERT-EK-2026-9814',
        steps: [
          JourneyStep(
            title: 'Scrap Collected',
            description: 'Scrap picked up from household and weighed.',
            location: 'Sector 62, Noida',
            timestamp: '18 Sep, 11:30 AM',
            isCompleted: true,
          ),
          JourneyStep(
            title: 'Collector Depot Verification',
            description: 'Scrap sorted & cataloged at regional collector hub.',
            location: 'Noida Central Hub',
            timestamp: '18 Sep, 02:15 PM',
            isCompleted: true,
          ),
          JourneyStep(
            title: 'Dispatched to Authorized Recycler',
            description: 'Material transferred in batch #B-912 to GreenLoop.',
            location: 'Greater Noida Industrial Zone',
            timestamp: '18 Sep, 05:00 PM',
            isCompleted: true,
          ),
          JourneyStep(
            title: 'Recycling Recorded & Certified',
            description: 'Polymer granules produced. Circular economy completed.',
            location: 'GreenLoop Processing Plant',
            timestamp: '19 Sep, 09:30 AM',
            isCompleted: true,
          ),
        ],
      ),
    ];
  }
}
