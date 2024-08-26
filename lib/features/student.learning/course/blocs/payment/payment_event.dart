part of 'payment_bloc.dart';

abstract class PaymentEvent {}

class InitiatePayment extends PaymentEvent {
  final int courseId;

  InitiatePayment(this.courseId);
}

class PaymentSuccess extends PaymentEvent {
  final SuccessPaymentRequest req;

  PaymentSuccess(this.req);
}

class PaymentFailure extends PaymentEvent {
  final String error;

  PaymentFailure(this.error);
}
