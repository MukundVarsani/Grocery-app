import 'package:flutter/material.dart';
import 'package:myshop/Admin/Common/show_stock_card.dart';
import 'package:myshop/Admin/Pages/add_Item_to_cat_page.dart';
import 'package:myshop/Admin/Pages/product_detail_Page.dart';
import 'package:myshop/Admin/Services/admin_services.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
import 'package:myshop/services/ProductServices/product_service.dart';
import 'package:myshop/utils/colors.dart';

class CategoryItem extends StatefulWidget {
  final String categoryName;
  const CategoryItem({super.key, required this.categoryName});

  @override
  State<CategoryItem> createState() => CategoryItemState();
}

//
class CategoryItemState extends State<CategoryItem> {
  static const List<Color> colors = [
    Color(0xFF2E7D32), // Dark Green
    Color(0xFF00796B), // Teal
    Color(0xFFFF5722), // Deep Orange,
    Color(0xFFFFC107), // Amber
    Color(0xFF3F51B5), // Indigo
  ];

  List<ProductModel>? categoryProduct;
  late ProductService _productService;

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
    getCatItems(widget.categoryName);
  }

  void getCatItems(String catName) async {
    categoryProduct =
        await _productService.getSingleCategoryProducts(category: catName);
    setState(() {});
  }

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
        body: (categoryProduct != null)
            ? (categoryProduct!.isNotEmpty)
                ? GridView.builder(
                    itemCount: categoryProduct!.length,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2),
                    itemBuilder: (_, i) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>  ItemDetailPage(product: ProductModel(),)
                                      ));
                        },
                        child: ShowStockCard(
                          imgUrl: categoryProduct?[i].imageUrl ??
                              "https://firebasestorage.googleapis.com/v0/b/grocerry-app-2fb25.appspot.com/o/ProductImage%2FFruits%2FApple?alt=media&token=e097551b-4297-4b9c-b754-8948a8258ff3",
                          name: categoryProduct?[i].name ?? "Null",
                          price: categoryProduct?[i].price ?? "NA",
                          quantity: categoryProduct?[i].stock ?? "NA",
                          cardColor: colors[i % 5],
                        ),
                      );
                    })
                : const Center(
                    child: Text("☹\nData Not found",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)))
            : const Center(child: CircularProgressIndicator()));
  }
}
