import 'package:flutter/material.dart';

class OrderItemCard extends StatelessWidget {
  final String quant;
  final String price;
  final String name;
  final String imageUrl;
  const OrderItemCard(
      {super.key,
      required this.quant,
      required this.price,
      required this.name,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 62,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                imageUrl,
                width: 42,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("1Kg , ₹ $price/-",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(
            width: 12,
          ),
          Column(
            children: [
              const Text(
                "Quantity",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(quant,
              textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.red)),
            ],
          ),
        
        
        ],
      ),
    );
  }
}
