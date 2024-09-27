import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/utils/colors.dart';


// ignore: must_be_immutable
class ShowStockCard extends StatelessWidget {
  ProductModel? product = ProductModel();
  final Color cardColor;
  final String imgUrl;
  final String name;
  final String quantity;
  final String price;
  ShowStockCard(
      {super.key,
      this.product,
      required this.cardColor,
      required this.imgUrl,
      required this.name,
      required this.quantity,
      required this.price});

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
            child: Image.network(imgUrl, fit:  BoxFit.contain,),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(19),
                    bottomRight: Radius.circular(19)),
                color: cardColor),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Name: ",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(name,
                        style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400))
                  ],
                ),
                Row(
                  children: [
                    const Text("Quantity: ",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text(quantity,
                        style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400))
                  ],
                ),
                Row(
                  children: [
                    const Text("Price: ",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text("₹ $price.00/-",
                        style:const  TextStyle(
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
