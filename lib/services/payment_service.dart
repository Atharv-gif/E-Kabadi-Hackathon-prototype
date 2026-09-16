import '../models/payment_model.dart';

abstract class PaymentService {
  Future<PaymentModel> processPayment({
    required String pickupId,
    required double amount,
    required String paymentMethod,
  });
}

class MockPaymentService implements PaymentService {
  @override
  Future<PaymentModel> processPayment({
    required String pickupId,
    required double amount,
    required String paymentMethod,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return PaymentModel(
      id: 'PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      pickupId: pickupId,
      amount: amount,
      method: paymentMethod,
      status: 'SUCCESS',
      transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      timestamp: 'Today, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      ecoPointsEarned: (amount / 5).round(),
    );
  }
}
