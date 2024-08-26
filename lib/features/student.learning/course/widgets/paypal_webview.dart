import 'package:educhain/features/student.learning/course/models/success_payment_request.dart';
import 'package:educhain/features/student.learning/course/payment_service.dart';
import 'package:educhain/features/student.learning/course/widgets/success_payment.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalWebViewScreen extends StatelessWidget {
  final String approvalUrl;

  const PayPalWebViewScreen({
    Key? key,
    required this.approvalUrl,
  }) : super(key: key);

  Future<void> _handleSuccess(BuildContext context, Uri uri) async {
    final paymentId = uri.queryParameters['paymentId'];
    final payerId = uri.queryParameters['PayerID'];
    final sum = uri.queryParameters['sum'];
    final courseId = uri.queryParameters['courseId'];

    if (paymentId != null &&
        payerId != null &&
        sum != null &&
        courseId != null) {
      final request = SuccessPaymentRequest(
        paymentId: paymentId,
        payerId: payerId,
        sum: double.parse(sum),
        courseId: int.parse(courseId),
      );

      PaymentService paymentService = PaymentService();

      final response = await paymentService.getSuccess(request);
      if (response.data != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(courseId: int.parse(courseId)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful, but failed to process.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PayPal Checkout')),
      body: WebView(
        initialUrl: approvalUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) {
          if (url.contains('success')) {
            final Uri uri = Uri.parse(url);
            _handleSuccess(context, uri);
          }
        },
      ),
    );
  }
}
