import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';


class OfferCard extends StatelessWidget {
  final Color color;
   const OfferCard({super.key,  required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 342,
      height: 148,
      decoration: BoxDecoration(
          color: AppColors.lightModeCardColor,
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              AppImages.offer,
              height: 248, // Adjust height to match container height
              fit: BoxFit.cover, // Ensure image covers the entire space
            ),
          ),
          const SizedBox(width: 1), // Adjust spacing between images if needed
          Expanded(
              flex: 1,
              child: Container(
                decoration:  BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Ramandan Offer",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    const Text(
                      "Get 25%",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        width: 130,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Text(
                                  "Grab Offer",
                                  style: TextStyle(color: AppColors.themeColor),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  size: 16,
                                  color: AppColors.themeColor,
                                )
                              ],
                            )))
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
