// ignore: file_names
import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';

class UserDetailCard extends StatelessWidget {
  final IconData icon;
  final String field;
  final String value;
  final int index;

  const UserDetailCard(
      {super.key,
      required this.icon,
      required this.field,
      required this.value,
      required this.index
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.greyColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    field,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 102, 105, 107)),
                  ),
                ],
              ),
              InkWell(
                  onTap: (index == 0) ? () {} : () {


                  },
                  child: Icon(Icons.edit,
                      color: (index == 0)
                          ? const Color.fromARGB(255, 102, 105, 107)
                          : AppColors.blackColor)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                "  $value",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor),
              )),
          const SizedBox(
            height: 15,
          ),
          const Divider(
            color: Colors.blueGrey,
            height: 0.5,
            thickness: 0.3,
          ),
        ],
      ),
    );
  }
}
