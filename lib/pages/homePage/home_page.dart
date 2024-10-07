import 'package:flutter/material.dart';
import 'package:myshop/Model/product_model.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:myshop/pages/categoryWiseItem/category_item.dart';
import 'package:myshop/pages/singleItemPage/item_detail_page.dart';
import 'package:myshop/pages/user_navigation_bar.dart';
import 'package:myshop/services/ProductServices/product_service.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/services/UserServices/user_services.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/widgets/features/best_selling.dart';
import 'package:myshop/widgets/global/category_avatar.dart';
import 'package:myshop/widgets/global/offer_card.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';



class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static const List<Map<String, String>> catItemsList = [
    {"catName": "Fruits", "catImage": AppImages.fruits},
    {"catName": "Vegetables", "catImage": AppImages.vegetables},
    {"catName": "Dairy", "catImage": AppImages.dairy},
    {"catName": "Meat", "catImage": AppImages.meat},
    {"catName": "Bakery", "catImage": AppImages.bakery},
  ];
  static const List<Color> offerCardCOlors = [
    Colors.orange,
    Colors.green,
    Colors.red,
  ];

  late UserServices _userServices;
  late UserProvider _userProvider;
  late ProductService _productService;
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  UserModel? currentUser;
  List<ProductModel> bestSelling = [];

  @override
  void initState() {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userServices = UserServices();
    _productService = ProductService();

    currentUser = _userProvider.getCurrentUser;

    if (currentUser != null) {
      _streetController.text = currentUser?.address?.street ?? "";
      _cityController.text = currentUser?.address?.city ?? "";
      _countryController.text = currentUser?.address?.country ?? "";
      _pinController.text = currentUser?.address?.postalCode ?? "";
    }
    getBestSelling();
    super.initState();
  }

  void getBestSelling() async {
    bestSelling = await _productService.getBestSelling();
    setState(() {});
  }

  void changeAddress() async {
    _userServices.updateAddress(
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      postalcode: _pinController.text.trim(),
      street: _streetController.text.trim(),
    );
    await _userProvider.setUser();
    currentUser = _userProvider.getCurrentUser;
    setState(() {});
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return SizedBox(
          width: 500,
          child: AlertDialog(
            backgroundColor: AppColors.lightModeCardColor,
            title: const Center(
                child: Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
            alignment: Alignment.center,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: 'Street: ',
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                            text: "${currentUser?.address?.street}, ",
                            style: const TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'city: ',
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                            text: "${currentUser?.address?.city}, ",
                            style: const TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Country: ',
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                            text: "${currentUser?.address?.country}, ",
                            style: const TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Pin: ',
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                            text: "${currentUser?.address?.postalCode}, ",
                            style: const TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      changeAddressDialog();
                    },
                    child: const Text('Change'),
                  ),
                  TextButton(
                    child: const Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> changeAddressDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SizedBox(
          width: 500,
          child: AlertDialog(
            backgroundColor: AppColors.lightModeCardColor,
            title: const Center(
                child: Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
            alignment: Alignment.center,
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Street",
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: currentUser?.address?.street ?? ' ',
                      hintStyle: const TextStyle(color: AppColors.greyColor),
                    ),
                    controller: _streetController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "City",
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: currentUser?.address?.city ?? ' ',
                      hintStyle: const TextStyle(color: AppColors.greyColor),
                    ),
                    controller: _cityController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Country",
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: currentUser?.address?.country ?? ' ',
                      hintStyle: const TextStyle(color: AppColors.greyColor),
                    ),
                    controller: _countryController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Pin",
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: currentUser?.address?.postalCode ?? ' ',
                      hintStyle: const TextStyle(color: AppColors.greyColor),
                    ),
                    controller: _pinController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      changeAddress();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Change'),
                  ),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (currentUser != null) {
                        _streetController.text =
                            currentUser?.address?.street ?? "";
                        _cityController.text = currentUser?.address?.city ?? "";
                        _countryController.text =
                            currentUser?.address?.country ?? "";
                        _pinController.text =
                            currentUser?.address?.postalCode ?? "";
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
                      InkWell(
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: PhotoView(
                                    minScale: PhotoViewComputedScale.contained,
                                    maxScale:
                                        PhotoViewComputedScale.covered * 2.0,
                                    backgroundDecoration: BoxDecoration(
                                        color: AppColors.blackColor
                                            .withOpacity(0.3)),
                                    customSize:
                                        const Size(double.infinity, 400),
                                    imageProvider: (currentUser != null)
                                        ? currentUser!.profileImage!.isNotEmpty
                                            ? NetworkImage(currentUser!
                                                .profileImage
                                                .toString())
                                            : const AssetImage(
                                                AppImages.userProfileImage)
                                        : const AssetImage(
                                            AppImages.userProfileImage)),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                            maxRadius: 25,
                            foregroundImage: (currentUser != null)
                                ? currentUser!.profileImage!.isNotEmpty
                                    ? NetworkImage(
                                        currentUser!.profileImage.toString())
                                    : const AssetImage(
                                        AppImages.userProfileImage)
                                : const AssetImage(AppImages.userProfileImage)),
                      ),
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
                              "${currentUser?.name}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 115,
                        height: 42,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            onTap: _showMyDialog,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(AppImages.myLocation),
                                const Text(
                                  "My Flat",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Icon(Icons.arrow_drop_down_sharp)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search category',
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        hintStyle: const TextStyle(color: AppColors.greyColor),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.greyColor,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.whiteColor, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColors.whiteColor, width: 2.0),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 148,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: offerCardCOlors.length,
                    itemBuilder: (context, index) =>
                        OfferCard(color: offerCardCOlors[index])),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ).copyWith(top: 40, bottom: 20),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   const Text(
                      "Categories 😋",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                          onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (_)=>const UserNavigationBar(index:1 ,)));
                          },
                      child:const Text(
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
                    
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CategoryItem(
                                      categoryName: catItemsList[index]
                                              ['catName'] ??
                                          '')));
                        },
                        child: CategoryCircle(
                            image: catItemsList[index]['catImage'] ??
                                AppImages.fruits))),
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
                                    builder: (_) => ItemDetailPage(
                                          product: bestSelling[index],
                                        )));
                          },
                          child: ItemCard(
                              price:
                                  bestSelling[index].price ?? "NA",
                              name: bestSelling[index].name ?? "NA",
                              image: bestSelling[index].imageUrl ?? " "
                                  ),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
