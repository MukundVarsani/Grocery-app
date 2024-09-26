import 'package:flutter/material.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/widgets/global/cart_item_card.dart';

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () {},
        ),
        title: const Text(
          "Cart 🛒",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 8,
          itemBuilder: (_, index) {
            return Column(
              children: [
                const CartItemCard(),
                if(index < 7) Container(
                       margin: const EdgeInsets.symmetric(vertical: 10).copyWith(top: 5),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 235, 232, 232)))),
                )
              ],
            );
          }),
    );
  }
}
