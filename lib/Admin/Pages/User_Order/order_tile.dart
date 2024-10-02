import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';

// ignore: must_be_immutable
class OrderTile extends StatelessWidget {
  final String orderId;
  final String statusCode;

  OrderTile({super.key, required this.orderId, required this.statusCode});

  String status = '';

  @override
  Widget build(BuildContext context) {
    switch (statusCode) {
      case '1':
        status = "Ordered Placed";
        break;
      case '2':
        status = "Out of Delivery";
        break;
      case '3':
        status = "Order Delivered";
        break;
      case '4':
        status = "Order Cancelled";
        break;

      default:
        status = "Order Failed";
        break;
    }
    return Container(
      color: const Color.fromARGB(255, 134, 220, 159),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      height: 70,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
            
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order_Id',
                    style:  TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(orderId,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(
            width: 8,
          ),
          Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Status",
               
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, ),
              ),
              Text(status,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }
}
