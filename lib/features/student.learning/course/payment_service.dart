import 'package:educhain/core/api_service.dart';
import 'package:educhain/core/types/api_response.dart';
import 'package:educhain/features/student.learning/course/models/success_payment_request.dart';

class PaymentService extends ApiService {
  ApiResponse<String> pay(int courseId) async {
    return postPaypal<String>(
      'api/paypal/pay/$courseId',
      null, // Directly interpret the response as a String
      null,
    );
  }

  ApiResponse<String> getSuccess(SuccessPaymentRequest req) async {
    final endpoint =
        'api/paypal/success?paymentId=${req.paymentId}&PayerID=${req.payerId}&sum=${req.sum}&courseId=${req.courseId}';

    return get<String>(
      endpoint,
      null,
    );
  }
}
