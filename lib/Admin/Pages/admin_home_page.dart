import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/add_Item_to_cat_page.dart';
import 'package:myshop/Admin/Pages/display_avail_Item.dart';
import 'package:myshop/Admin/Pages/product_detail_Page.dart';
import 'package:myshop/Admin/Pages/see_all_items_page.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:myshop/Resources/auth/sign_in.dart';
import 'package:myshop/pages/allItemPage/all_items.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
import 'package:myshop/services/ProductServices/product_service.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/utils/utils.dart';
import 'package:myshop/widgets/features/best_selling.dart';
import 'package:myshop/widgets/global/button.dart';

import 'package:myshop/widgets/global/category_avatar.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  static const List<Map<String, String>> catItemsList = [
    {"catName": "Fruits", "catImage": AppImages.fruits},
    {"catName": "Vegetables", "catImage": AppImages.vegetables},
    {"catName": "Dairy", "catImage": AppImages.dairy},
    {"catName": "Meat", "catImage": AppImages.meat},
    {"catName": "Bakery", "catImage": AppImages.bakery},
  ];

  bool isLoggedOut = false;

  late UserProvider _userProvider;
  late ProductService _productService;

  UserModel? _currentUser;

  List<ProductModel> bestSelling = [];

  List<String> field = ["Email", "Street", "City", "Country", "Postal Code"];

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _currentUser = _userProvider.getCurrentUser;
    _productService = ProductService();
    getBestSelling();
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();

    isLoggedOut = await Utils.removeToken();
    _userProvider.deleteUser();

    if (isLoggedOut) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignInPage()),
          (route) => false);
    }
  }

  void getBestSelling() async {
    bestSelling = await _productService.getBestSelling();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightModeCardColor,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(


            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(bottom: 20),
                color: AppColors.lightModeCardColor,
                child: Column(
                  children: [
                    Row(children: [
                      CircleAvatar(
                          maxRadius: 25,
                          foregroundImage: (_currentUser != null)
                              ? _currentUser!.profileImage!.isNotEmpty
                                  ? NetworkImage(
                                      _currentUser!.profileImage.toString())
                                  : const AssetImage(AppImages.userProfileImage)
                              : const AssetImage(AppImages.userProfileImage)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Have a Good life!",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.greyColor),
                            ),
                            Text(
                              "${_currentUser?.name}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: logoutUser,
                          icon: const Icon(
                            Icons.logout,
                            color: AppColors.blackColor,
                          ))
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ).copyWith(top: 40, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Categories 😋",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SeeAllItemsPage()));
                      },
                      child: const Text(
                        "See all",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.themeColor),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 73,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: catItemsList.length,
                    itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DisplayAvailabeItem(
                                      categoryName: catItemsList[index]
                                              ['catName']
                                          .toString())));
                        },
                        child: CategoryCircle(
                            image:
                                catItemsList[index]['catImage'].toString()))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ).copyWith(top: 40, bottom: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Best Selling 💥",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.themeColor),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 214,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bestSelling.length,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProductDetailPage(
                                          product: bestSelling[index],
                                        )));
                          },
                          child: ItemCard(
                              price: bestSelling[index].price ?? "NA",
                              name: bestSelling[index].name ?? "NA",
                              image: bestSelling[index].imageUrl ?? " "),
                        )),
              ),

             const  Spacer(),
               
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: PrimaryButton(
                      title: "Add Item to cart",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddItemToCart()));
                      }),
              ),
              const SizedBox(height: 20,),
              
            ],
          ),
   
      ),
    );
  }
}
