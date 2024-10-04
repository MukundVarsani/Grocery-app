import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';

import 'package:myshop/services/ProductServices/product_service.dart';
import 'package:myshop/utils/colors.dart';

import 'package:myshop/widgets/features/best_selling.dart';
import 'package:velocity_x/velocity_x.dart';

class AllItemsPage extends StatefulWidget {
  const AllItemsPage({super.key});

  @override
  State<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  List<ProductModel> allProducts = [];
  List<ProductModel> filterdProducts = [];

  final ProductService _productService = ProductService();
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
    filterdProducts = allProducts;

    setState(() {
      isLoading = false;
    });
  }

  void filterByLowPrice() {
    filterdProducts.sort(
      (a, b) => int.parse(a.price!).compareTo(int.parse(b.price!)),
    );
    Navigator.pop(context);
    setState(() {
      isPriceUp = !isPriceUp;
    });
  }

  void filterByHighPrice() {
    filterdProducts.sort(
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
        elevation: 0,
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

            filterdProducts = allProducts;
          },
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isSearching
              ? Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: VxTextField(
                    clear: false,
                    enableSuggestions: true,
                    fillColor: Colors.white,
                    borderColor: AppColors.whiteColor,
                    borderType: VxTextFieldBorderType.roundLine,
                    borderRadius: 10,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.themeColor,
                    ),
                    onChanged: (query) {
                      List<ProductModel> filtered =
                          allProducts.where((product) {
                        final productName = product.name?.toLowerCase() ?? "";
                        final input = query.toLowerCase();

                        return productName.contains(input);
                      }).toList();

                      setState(() {
                        filterdProducts = filtered;
                      });
                    },
                    cursorColor: AppColors.themeColor,
                    style: const TextStyle(color: AppColors.themeColor),
                  ),
                )
              : const Text(
                  "All Items",
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
      body: isLoading ? 
     const  Center(child: CircularProgressIndicator(),)
      : filterdProducts.isEmpty
          ?  Container(
                color: AppColors.lightModeCardColor,
                height: double.maxFinite,
                width: double.maxFinite,

                child:const Center(
                  child:   Text(
                    "No Item Found",
                    style: TextStyle(
                        color: AppColors.themeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            
          : GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: 163 / 180),
              itemCount: filterdProducts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => ItemDetailPage(
                            product: filterdProducts[index],
                          ),
                        ))
                  },
                  child: ItemCard(
                      image: filterdProducts[index].imageUrl ?? "",
                      name: filterdProducts[index].name ?? "NA",
                      price: filterdProducts[index].price ?? "Na"),
                );
              },
            ),
    );
  }
}
