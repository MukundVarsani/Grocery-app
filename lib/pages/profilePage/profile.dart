// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:myshop/Resources/Firebase_storage/storage_method.dart';
import 'package:myshop/Resources/auth/sign_in.dart';
import 'package:myshop/pages/profilePage/userDetailCard.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/services/UserServices/user_services.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/utils/pick_image.dart';
import 'package:myshop/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  late UserModel? currentUser;
  bool isLoggedOut = false;

  List<String> value = [];
  List<IconData> listIcons = [
    Icons.email,
    Icons.add_home,
    Icons.gps_fixed,
    Icons.add_location,
    Icons.pin_drop,
  ];

  UserProvider? _userProvider;
  late UserServices _userServices;

  List<String> field = ["Email", "Street", "City", "Country", "Postal Code"];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _userServices = UserServices();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    if (_userProvider != null) {
      currentUser = _userProvider?.getCurrentUser;
    }

    if (currentUser != null) {
      value = [
        currentUser!.email.toString(),
        currentUser!.address?.street.toString() ?? "null",
        currentUser!.address?.city.toString() ?? "null",
        currentUser!.address?.country.toString() ?? "null",
        currentUser!.address?.postalCode.toString() ?? "null",
      ];
    }
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    isLoggedOut = await Utils.removeToken();

    if (_userProvider != null) {
      _userProvider?.deleteUser();
    }
    if (isLoggedOut) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignInPage()),
          (route) => false);
    }
  }

  void changeAddress() async {
    _userServices.updateAddress(
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      postalcode: _postalCodeController.text.trim(),
      street: _streetController.text.trim(),
    );

    await _userProvider?.setUser();
    currentUser = _userProvider?.getCurrentUser;
  }

  void setProfileImage() async {
    Uint8List? file = await pickImage(ImageSource.gallery);
    if (file.isNotEmpty) {
      String profileURL = await StorageMethod().uploadUserProfileImageToCloud(
          childName: 'profile-pics', file: file, context: context);

      if (profileURL.isNotEmptyAndNotNull) {
        _userServices.setUserProfilePic(profileURL);

        await _userProvider?.setUser();
        currentUser = _userProvider?.getCurrentUser;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          leadingWidth: 70,
          backgroundColor: AppColors.themeColor,
          leading: Container(
            margin: const EdgeInsets.only(left: 20),
            height: 50,
            width: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: IconButton(
              tooltip: "Log out",
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              onPressed: logoutUser,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ],
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              height: 250,
              padding: const EdgeInsets.only(top: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: AppColors.themeColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  Stack(children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (currentUser != null)
                            ? currentUser!.profileImage.isNotEmptyAndNotNull
                                ? Image.network(
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: CircularProgressIndicator
                                              .adaptive(
                                            backgroundColor:
                                                AppColors.whiteColor,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              AppColors.themeColor,
                                            ),
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    currentUser!.profileImage.toString(),
                                  )
                                : Image.asset(
                                    AppImages.userProfileImage,
                                  )
                            : Image.asset(AppImages.userProfileImage),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: setProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: const Icon(
                              size: 24,
                              Icons.edit,
                              color: AppColors.blackColor,
                            ),
                          ),
                        )),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    currentUser != null ? currentUser!.name.toString() : "null",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    currentUser != null
                        ? currentUser!.email.toString()
                        : "null",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                    itemCount: field.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: UserDetailCard(
                          index: i,
                          field: field[i],
                          icon: listIcons[i],
                          value: currentUser != null ? value[i] : "null",
                        ),
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
