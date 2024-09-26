import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20 ),
 
      height: 62,
   
      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
      
            children: [
              Image.asset(
                AppImages.pepper,
                width: 42,
              ),
              const SizedBox(width: 20,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bell Pepper Red" , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),),
                  Text(
                    "1Kg , 2\$",
                    style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold , color: Colors.red)
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 116,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                        color: AppColors.lightModeCardColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove),
                      color: AppColors.greyColor,
                      iconSize: 20,
                    )),
                const Text(
                  "4",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                        color: AppColors.themeColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      color: AppColors.whiteColor,
                      iconSize: 20,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
