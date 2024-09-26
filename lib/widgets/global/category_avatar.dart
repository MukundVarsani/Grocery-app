import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';

class CategoryCircle extends StatelessWidget {
  final String image;
  const CategoryCircle({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
          child: Container(
              height: 73,
              width: 73,
              color: AppColors.lightModeCardColor,
              child: Image.asset(
                image,
                height: 35,
                width: 35,
              ))),
    );
  }
}
