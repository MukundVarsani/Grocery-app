import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';

class ItemCard extends StatelessWidget {
  final double price;
  final String name;
  final String image;

  const ItemCard(
      {super.key,
      required this.price,
      required this.name,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 163,
      height: 214,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
          color: AppColors.lightModeCardColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(image),
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
        
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "1Kg, ${price.toInt()}\$",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            color: AppColors.themeColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.whiteColor,
                        )),
                  ],
                
              ),
            ],
          ),
        ],
      ),
    );
  }
}
