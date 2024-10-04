import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myshop/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class PayementServices {
  PayementServices._();

  static final PayementServices instance = PayementServices._();

  Future<bool> makePayment(int amount) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymetnIntent(amount, 'usd');

      if (paymentIntentClientSecret == null) return false;

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Mukund Store",
      ));

      await _processPayment();
      return true;
    } catch (e) {
      Vx.log("Error while making payment $e");
      return false;
    }
  }

  Future<String?> _createPaymetnIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();

      Map<String, dynamic> data = {
        "amount": _calculateAmunt(amount),
        "currency": currency
      };

      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          }));

      if (response.data != null) {
        return response.data['client_secret'];
      }

      return "";
    } catch (e) {
      Vx.log("Error while making payment Intent $e");

      return null;
    }
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Stripe.instance.confirmPaymentSheetPayment().then((ds) {
        return true;
      });
     
    } catch (e) {
      Vx.log("Error while processing payment Intent $e");
    }
      return false;
  }

  String _calculateAmunt(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
