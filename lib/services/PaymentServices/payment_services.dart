import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myshop/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentServices {
  PaymentServices._();

  static final PaymentServices instance = PaymentServices._();

  Future<bool> makePayment(int amount) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount, 'usd');

      if (paymentIntentClientSecret == null) return false;

      // Initialize the payment sheet with the client secret and other parameters
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Mukund Store",
      ));

      // Process the payment and return its result
      bool paymentResult = await _processPayment();
      return paymentResult;
    } catch (e) {
      Vx.log("Error while making payment: $e");
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();

      // Data for the payment intent creation
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      // Sending request to create a payment intent
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          }));

      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      Vx.log("Error while creating payment intent: $e");
      return null;
    }
  }

  Future<bool> _processPayment() async {
    try {
      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // Confirm the payment after presenting the sheet

      Vx.log("OShayfdasfsfjnasfjasn fjaskbfukasnfasf");
      // If the process succeeds, return true
      return true;
    } catch (e) {
      Vx.log("Error while processing payment: $e");
      return false; // Return false in case of failure
    }
  }

  // Helper to calculate the amount (in cents)
  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Stripe expects amount in cents
    return calculatedAmount.toString();
  }
}
