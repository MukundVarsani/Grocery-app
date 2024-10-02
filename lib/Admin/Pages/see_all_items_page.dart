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
        backgroundColor: AppColors.themeColor,
        elevation: 0,
        title: const Text(
          "All Products",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.whiteColor),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: AppColors.whiteColor,))],
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 16),
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
