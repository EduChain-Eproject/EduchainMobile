import 'package:bloc/bloc.dart';
import 'package:educhain/features/student.learning/course/models/success_payment_request.dart';
import 'package:educhain/features/student.learning/course/payment_service.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService paymentService; // Payment service

  PaymentBloc(this.paymentService) : super(PaymentInitial()) {
    on<InitiatePayment>((event, emit) async {
      emit(PaymentLoading());
      final response = await paymentService.pay(event.courseId);
      print(response.toString());
      await response.on(
          onSuccess: (payment) => emit(PaymentSuccessState(payment)),
          onError: (error) => emit(PaymentFailureState(error)));
    });

    on<PaymentSuccess>((event, emit) async {
      emit(PaymentLoading());
      final response = await paymentService.getSuccess(event.req);
      await response.on(
          onSuccess: (payment) => emit(PaymentSuccessState(payment)),
          onError: (error) => emit(PaymentFailureState(error)));
    });

    on<PaymentFailure>((event, emit) {
      (error) => emit(PaymentFailureState(error));
    });
  }
}
