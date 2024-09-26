import 'package:flutter/material.dart';
import 'package:myshop/Admin/Common/show_stock_card.dart';
import 'package:myshop/utils/colors.dart';

class DisplayAvailabeItem extends StatefulWidget {
  const DisplayAvailabeItem({super.key});

  @override
  State<DisplayAvailabeItem> createState() => _DisplayAvailabeItemState();
} 
// 
class _DisplayAvailabeItemState extends State<DisplayAvailabeItem> {
  static const List<Color> colors = [
    Color(0xFF2E7D32), // Dark Green
    Color(0xFF00796B), // Teal
    Color(0xFFFF5722), // Deep Orange,
    Color(0xFFFFC107), // Amber
    Color(0xFF3F51B5), // Indigo
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const BackButtonIcon(),
          color: AppColors.whiteColor,
        ),
        backgroundColor: AppColors.themeColor,
        title: const Text("Available Stock",
            style: TextStyle(
                color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: GridView.builder(
          itemCount: 10,
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 2),
          itemBuilder: (_, i) {
            return ShowStockCard(
              cardColor: colors[i % 5],
            );
          }),
    );
  }
}
