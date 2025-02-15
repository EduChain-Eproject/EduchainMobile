part of 'payment_bloc.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccessState extends PaymentState {
  final String approvalUrl;

  PaymentSuccessState(this.approvalUrl);
}

class PaymentFailureState extends PaymentState {
  final Map<String, dynamic>? errors;

  PaymentFailureState(this.errors);
}
