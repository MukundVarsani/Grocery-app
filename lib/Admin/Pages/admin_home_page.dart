import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/display_avail_Item.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';

import 'package:myshop/widgets/global/category_avatar.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  static const List<Map<String, String>> catItemsList = [
    {"catName": "Fruits", "catImage": AppImages.fruits},
    {"catName": "Vegetable", "catImage": AppImages.vegetables},
    {"catName": "Dairy", "catImage": AppImages.dairy},
    {"catName": "Meat", "catImage": AppImages.meat},
  ];
  // AppImages.fruits,
  // AppImages.vegetables,
  // AppImages.dairy,
  // AppImages.meat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightModeCardColor,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(bottom: 20),
                color: AppColors.lightModeCardColor,
                child: const Column(
                  children: [
                    Row(children: [
                      CircleAvatar(
                          maxRadius: 25,
                          foregroundImage:
                              AssetImage(AppImages.userProfileImage)),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Have a Good life!",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.greyColor),
                            ),
                            Text(
                              "Mukund",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories 😋",
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
                height: 73,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: catItemsList.length,
                    itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DisplayAvailabeItem(categoryName: catItemsList[index]['catName'].toString())));
                        },
                        child: CategoryCircle(
                            image:
                                catItemsList[index]['catImage'].toString()))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
