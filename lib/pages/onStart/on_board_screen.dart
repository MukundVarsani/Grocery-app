// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/admin_home_page.dart';
import 'package:myshop/Resources/auth/sign_in.dart';
import 'package:myshop/pages/bottom_navigation_bar.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/utils/utils.dart';
import 'package:myshop/widgets/global/button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  bool isLoggedIn = false;
  bool isAdmin = false;

  late UserProvider _userProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    getUserId();

    Timer(const Duration(seconds: 2), () async {
      if (isLoggedIn) {
        await _userProvider.setUser();
        _userProvider = Provider.of<UserProvider>(context, listen: false);

        isAdmin = _userProvider.getCurrentUser?.role == 'Admin' ? true : false;
       
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => isLoggedIn
                  ? isAdmin
                      ? const AdminHomePage()
                      : const BottomNavigationBare()
                  : const SignInPage()));
    });
  }

  void getUserId() async {
    User? user = _auth.currentUser;
    String uid = await Utils.getToken();

    if (user != null) {
      isLoggedIn = user.uid == uid ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color.fromARGB(255, 233, 248, 234),
                Colors.white,
                Colors.white,
                Colors.white
              ], // List of colors
              begin: Alignment.topRight, // Start point
              end: Alignment.bottomLeft, // End point
            ),
          ),
          child: Stack(children: [
            Positioned(
              right: 25,
              top: 50,
              child: Image.asset(AppImages.leaf2),
            ),
            Positioned(
              right: 0,
              top: 440,
              child: Image.asset(AppImages.blurLeaf),
            ),
            Positioned(
              left: 20,
              top: 520,
              child: Image.asset(AppImages.leaf1),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 130,
                ),
                Center(
                  child: Image.asset(
                    AppImages.splashImage,
                    height: 66,
                    width: 66,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Get your groceries \ndeleveried to your home",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "The best delivery app in town for\ndelivering your daily fresh groceries",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.grey.withOpacity(0.7),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 190,
                  height: 50,
                  child: PrimaryButton(title: "Shop now", onPressed: () {}),
                ),
                const Spacer(),
                //  Image.asset(AppImages.onBoardImage ,height: 338,width: 500,)
                SizedBox(
                  width: 500,
                  height: 338,
                  child: Image.asset(
                    AppImages.onBoardImage,
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
          ])),
    );
  }
}
