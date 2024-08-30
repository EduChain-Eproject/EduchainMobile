import 'package:educhain/core/theme/app_pallete.dart';
import 'package:educhain/features/student.learning/course/models/success_payment_request.dart';
import 'package:educhain/features/student.learning/course/payment_service.dart';
import 'package:educhain/features/student.learning/course/screens/success_payment_screen.dart';
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

      try {
        final response = await paymentService.getSuccess(request);
        if (response.data != null) {
          _navigateToSuccessScreen(context, int.parse(courseId));
        } else {
          _showErrorSnackBar(
              context, 'Payment successful, but failed to process.');
        }
      } catch (e) {
        _showErrorSnackBar(context, 'An error occurred: ${e.toString()}');
      }
    } else {
      _showErrorSnackBar(context, 'Invalid payment details.');
    }
  }

  void _navigateToSuccessScreen(BuildContext context, int courseId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPaymentScreen(courseId: courseId),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _confirmNavigation(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);

    if (url.contains('success')) {
      bool confirm = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Payment Confirmation',
                  style: TextStyle(color: AppPallete.successColor),
                ),
                content: const Text(
                  'Do you want to proceed with this payment?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Proceed'),
                  ),
                ],
              );
            },
          ) ??
          false;

      if (confirm) {
        _handleSuccess(context, uri);
      } else {
        Navigator.of(context).pop();
      }
    } else if (url.contains('cancel')) {
      Navigator.of(context).pop(); // Close the WebView on cancel.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PayPal Checkout')),
      body: WebView(
        initialUrl: approvalUrl,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          final url = request.url;
          if (url.contains('success') || url.contains('cancel')) {
            _confirmNavigation(context, url);
            return NavigationDecision
                .prevent; // Prevent the WebView from loading the URL.
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
