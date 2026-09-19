import '../models/payment_model.dart';

abstract class PaymentRepository {
  Future<List<PaymentModel>> getPaymentHistory();
  Future<PaymentModel> recordPayment(PaymentModel payment);
}

class MockPaymentRepository implements PaymentRepository {
  final List<PaymentModel> _payments = [
    // Rewards always derived from the final verified bill:
    // ₹850 ≥ ₹500 → 85 points (10%).
    const PaymentModel(
      id: 'PAY-901',
      pickupId: 'PK-8320',
      amount: 850.0,
      method: 'UPI (Google Pay)',
      status: 'SUCCESS',
      transactionId: 'TXN948102948',
      timestamp: '15 Sep 2026, 02:45 PM',
      ecoPointsEarned: 85,
    ),
    // ₹430 < ₹500 → 0 points for citizens.
    const PaymentModel(
      id: 'PAY-890',
      pickupId: 'PK-7210',
      amount: 430.0,
      method: 'UPI (PhonePe)',
      status: 'SUCCESS',
      transactionId: 'TXN823901823',
      timestamp: '08 Sep 2026, 11:20 AM',
      ecoPointsEarned: 0,
    ),
  ];

  @override
  Future<List<PaymentModel>> getPaymentHistory() async {
    return _payments;
  }

  @override
  Future<PaymentModel> recordPayment(PaymentModel payment) async {
    _payments.insert(0, payment);
    return payment;
  }
}
