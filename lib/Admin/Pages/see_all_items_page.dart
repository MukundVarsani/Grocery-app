import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/product_detail_Page.dart';
import 'package:myshop/Model/product_model.dart';


import 'package:myshop/services/ProductServices/product_service.dart';
import 'package:myshop/utils/colors.dart';

import 'package:myshop/widgets/features/best_selling.dart';

class SeeAllItemsPage extends StatefulWidget {
  const SeeAllItemsPage({super.key});

  @override
  State<SeeAllItemsPage> createState() => _SeeAllItemsPageState();
}

class _SeeAllItemsPageState extends State<SeeAllItemsPage> {
  List<ProductModel> allProducts = [];

  final ProductService _productService = ProductService();
  @override
  void initState() {
    getAllProducts();
    super.initState();
  }

  void getAllProducts() async {
    allProducts = await ProductService().getAllAvailableItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Vegetables 🌽",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            childAspectRatio: 163 / 180),
        itemCount: allProducts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => ProductDetailPage(product: allProducts[index]),
                  ))
            },
            child: ItemCard(
                image: allProducts[index].imageUrl ?? "",
                name: allProducts[index].name ?? "NA",
                price: allProducts[index].price ?? "Na"),
          );
        },
      ),
    );
  }
}
