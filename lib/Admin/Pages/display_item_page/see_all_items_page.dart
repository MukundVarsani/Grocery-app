import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Admin/Pages/Product_detail_page/product_detail_Page.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/bloc/ProductBloc/GetAllProducts_Cubit/get_all_products_cubit.dart';
import 'package:myshop/services/ProductServices/product_service.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/widgets/features/best_selling.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc/ProductBloc/GetAllProducts_Cubit/get_all_products_state.dart';

class SeeAllItemsPage extends StatefulWidget {
  const SeeAllItemsPage({super.key});

  @override
  State<SeeAllItemsPage> createState() => _SeeAllItemsPageState();
}

class _SeeAllItemsPageState extends State<SeeAllItemsPage> {
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProduct = [];
  final ProductService _productService = ProductService();

  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  bool isPriceUp = false;
  bool isLoading = false;

  @override
  void initState() {
    getAllProducts();
    super.initState();
  }

  void getAllProducts() async {
    setState(() {
      isLoading = true;
    });
    allProducts = await ProductService().getAllAvailableItems();
    filteredProduct = allProducts;
    setState(() {
      isLoading = false;
    });
  }

  void filterByLowPrice() {
    filteredProduct.sort(
      (a, b) => int.parse(a.price!).compareTo(int.parse(b.price!)),
    );
    Navigator.pop(context);
    setState(() {
      isPriceUp = !isPriceUp;
    });
  }

  void filterByHighPrice() {
    filteredProduct.sort(
      (a, b) => int.parse(b.price!).compareTo(int.parse(a.price!)),
    );
    Navigator.pop(context);
    setState(() {
      isPriceUp = !isPriceUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          iconSize: 24,
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: AppColors.whiteColor,
          ),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });

            filteredProduct = allProducts;
          },
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isSearching
              ? Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: VxTextField(
                    clear: false,
                    autofocus: true,
                    enableSuggestions: true,
                    fillColor: Colors.white,
                    borderColor: AppColors.whiteColor,
                    borderType: VxTextFieldBorderType.roundLine,
                    borderRadius: 10,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.themeColor,
                    ),
                    onChanged: (email) {
                      List<ProductModel> filtered =
                          allProducts.where((product) {
                        final productName = product.name?.toLowerCase() ?? '';
                        final input = email.toLowerCase();
                        return productName.contains(input);
                      }).toList();

                      setState(() {
                        filteredProduct = filtered;
                      });
                    },
                    cursorColor: AppColors.themeColor,
                    style: const TextStyle(color: AppColors.themeColor),
                  ),
                )
              : const Text(
                  "All Products",
                  key: ValueKey('titleText'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.whiteColor),
                ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    useSafeArea: true,
                    barrierColor: Colors.transparent,
                    builder: (_) {
                      return Stack(
                        children: [
                          Positioned(
                              right: 5,
                              top: 55,
                              child: Container(
                                height: 110,
                                width: 200,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(5, 5),
                                          blurRadius: 10)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Sort by : ",
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),

                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        itemBuilder: (_, index) {
                                          return GestureDetector(
                                            onTap: isPriceUp
                                                ? filterByLowPrice
                                                : filterByHighPrice,
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 2),
                                              width: double.infinity,
                                              child: Text(
                                                "Price ${!isPriceUp ? "↑" : "↓"} ",
                                                style: const TextStyle(
                                                    color: AppColors.themeColor,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          );
                                        })
                                    //
                                  ],
                                ),
                              ))
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.filter_alt,
                color: AppColors.whiteColor,
              ))
        ],
        centerTitle: true,
      ),
      body: BlocBuilder<GetAllProductsCubit, GetAllProductsState>(
          builder: (context, state) {
        if (state is GetAllProductsLoadingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: AppColors.whiteColor,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.themeColor),
            ),
          );
        } else if (state is GetAllProductsErrorState) {
          return const Center(
            child: Text(
              "No Item Found",
              style: TextStyle(
                  color: AppColors.themeColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          );
        }

        if (state is GetAllProductsLoadedState) {
          if (filteredProduct.isEmpty) {
            allProducts = state.products;
            filteredProduct = allProducts;
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              childAspectRatio: 163 / 180,
            ),
            itemCount: filteredProduct.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) =>
                          ProductDetailPage(product: filteredProduct[index]),
                    ),
                  )
                },
                child: ItemCard(
                  image: filteredProduct[index].imageUrl ?? "",
                  name: filteredProduct[index].name ?? "NA",
                  price: filteredProduct[index].price ?? "NA",
                ),
              );
            },
          );
        }
        return const Center(
          child: Text(
            "Error while geting product",
            style: TextStyle(
                color: AppColors.themeColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
        );
      }),
    );
  }
}
