
import 'package:flutter/material.dart';

import 'package:myshop/utils/colors.dart';


class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool? isLoading;
  final FocusNode? node;

  const PrimaryButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.isLoading,
      this.node});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      focusNode: node,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          minimumSize: Size(MediaQuery.of(context).size.width, 44),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11))),
      child: isLoading == true
          ? const CircularProgressIndicator(
              color: AppColors.whiteColor,
            )
          : Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
    );
  }
}
