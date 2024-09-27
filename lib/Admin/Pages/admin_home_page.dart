import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/display_avail_Item.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:myshop/Resources/auth/sign_in.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/utils/utils.dart';

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

  UserModel? _currentUser;

  List<String> field = ["Email", "Street", "City", "Country", "Postal Code"];

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _currentUser = _userProvider.getCurrentUser;
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
                child: Column(
                  children: [
                    Row(children: [
                      CircleAvatar(
                          maxRadius: 25,
                          foregroundImage:
                             (_currentUser != null)
                              ? _currentUser!.profileImage!.isNotEmpty
                                  ? NetworkImage(
                                      _currentUser!.profileImage.toString())
                                  : const AssetImage(AppImages.userProfileImage)
                              : const AssetImage(AppImages.userProfileImage)
                              
                          ),
                       Padding(
                        padding:const EdgeInsets.only(left: 10),
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
                                  builder: (_) => DisplayAvailabeItem(
                                      categoryName: catItemsList[index]
                                              ['catName']
                                          .toString())));
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
