
import 'package:flutter/material.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
import 'package:myshop/Model/best_selling.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/widgets/features/best_selling.dart';

class AllItemsPage extends StatefulWidget {
  const AllItemsPage({super.key});

  @override
  State<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  static List<ItemCardModel> bestSellingItems = [
    ItemCardModel(
        itemImage: AppImages.pepper, itemName: "Bell Pepper Red", itemPrice: 6),
    ItemCardModel(
        itemImage: AppImages.ginger, itemName: "Arabic Ginger", itemPrice: 4),
           ItemCardModel(
        itemImage: AppImages.cabbage, itemName: "Fresh Lettuce", itemPrice: 2),
           ItemCardModel(
        itemImage: AppImages.squash, itemName: "Butternut Squash", itemPrice: 8),
    ItemCardModel(
        itemImage: AppImages.rawMeat, itemName: "Organic Carrots", itemPrice: 4),
    ItemCardModel(
        itemImage: AppImages.brocolli, itemName: "Fresh Broccoli", itemPrice: 2),
           ItemCardModel(
        itemImage: AppImages.tomoto, itemName: "Red Tomoto", itemPrice: 3),
    ItemCardModel(
        itemImage: AppImages.ginger, itemName: "Fresh Spinach", itemPrice: 2),
  ];

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
          "Vegetables 🌽",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        centerTitle: true,
      ),
      body: 
      
      GridView.builder(

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          childAspectRatio: 163/180
          ),
        itemCount: bestSellingItems.length,
        
        itemBuilder: (context, index) {
         
          return InkWell(
            onTap: ()=>{
              Navigator.push(context, MaterialPageRoute(builder: (c)=>
                  const ItemDetailPage(),
              ))
            },
            child: ItemCard(
                  image: bestSellingItems[index].itemImage,
                  name: bestSellingItems[index].itemName,
                  price: bestSellingItems[index].itemPrice),
          );
        },
      ),
    );
  }
}
