class SuccessPaymentRequest {
  final String paymentId;
  final String payerId;
  final double sum;
  final int courseId;

  SuccessPaymentRequest({
    required this.paymentId,
    required this.payerId,
    required this.sum,
    required this.courseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'payerId': payerId,
      'sum': sum,
      'courseId': courseId,
    };
  }
}
