class PaymentModel {
  final String id;
  final String pickupId;
  final double amount;
  final String method;
  final String status;
  final String transactionId;
  final String timestamp;
  final int ecoPointsEarned;

  const PaymentModel({
    required this.id,
    required this.pickupId,
    required this.amount,
    this.method = 'UPI / GPay',
    this.status = 'SUCCESS',
    required this.transactionId,
    required this.timestamp,
    this.ecoPointsEarned = 20,
  });
}
