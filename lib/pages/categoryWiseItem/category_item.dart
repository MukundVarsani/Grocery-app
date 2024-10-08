import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Admin/Common/show_stock_card.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/bloc/ProductBloc/GetCatProduct_Cubit/get_cat_product_cubit.dart';
import 'package:myshop/bloc/ProductBloc/GetCatProduct_Cubit/get_cat_product_state.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
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

  @override
  void initState() {
    super.initState();

    BlocProvider.of<GetCatProductCubit>(context)
        .categoryWiseProduct(category: widget.categoryName);
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
      body: BlocBuilder<GetCatProductCubit, GetCatProductState>(
        builder: (c, state) {
          if (state is GetCatProductLoadingState) {
            return const Center(
                child: CircularProgressIndicator.adaptive(
                  
              backgroundColor: AppColors.whiteColor,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.themeColor),
            ));
          }

          if (state is GetCatProductLoadedState) {
            List<ProductModel> catProducts = state.products;

            return GridView.builder(
                itemCount: catProducts.length,
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2),
                itemBuilder: (_, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ItemDetailPage(
                                    product: catProducts[i],
                                  )));
                    },
                    child: ShowStockCard(
                      imgUrl: catProducts[i].imageUrl ??
                          "https://firebasestorage.googleapis.com/v0/b/grocerry-app-2fb25.appspot.com/o/ProductImage%2FFruits%2FApple?alt=media&token=e097551b-4297-4b9c-b754-8948a8258ff3",
                      name: catProducts[i].name ?? "Null",
                      price: catProducts[i].price ?? "NA",
                      quantity: catProducts[i].stock ?? "NA",
                      cardColor: colors[i % 5],
                    ),
                  );
                });
          }

          return const Center(
            child: Text(
              "Error while Getting Best Selling",
              style: TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          );
        },
      ),
    );
  }
}
