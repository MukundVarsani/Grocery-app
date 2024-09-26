import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';

// ignore: must_be_immutable
class ShowStockCard extends StatelessWidget {
  ProductModel? product = ProductModel();
  final Color cardColor;
  ShowStockCard({super.key, this.product, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardColor, width: 1),
          color: AppColors.lightModeCardColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: double.infinity,
            height: 70,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Image.asset(AppImages.brocolli),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration:  BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19)),
                color: cardColor),
            child: const Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Name: ",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("Cherry",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400))
                  ],
                ),
                Row(
                  children: [
                    Text("Quantity: ",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text("200",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400))
                  ],
                ),
                Row(
                  children: [
                    Text("Price: ",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text("₹ 20.00/-",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
