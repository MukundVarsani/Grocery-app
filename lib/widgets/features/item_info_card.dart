import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';

class ItemInfoCard extends StatelessWidget {
  final String infoImage;
  final String infoValue;
  final String infoDesc;

  const ItemInfoCard({super.key, required this.infoImage, required this.infoValue, required this.infoDesc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightModeCardColor, width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
           infoImage,
            width: 35,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                infoValue,
                style:const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.themeColor),
              ),
              Text(
                infoDesc,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
