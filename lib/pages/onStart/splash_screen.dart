import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myshop/pages/onStart/on_board_screen.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   @override  
  void initState() {  
    super.initState();  
    Timer(const Duration(seconds: 2),  
            ()=>Navigator.pushReplacement(context,  
            MaterialPageRoute(builder:  
                (context) => const OnBoardScreen()
            )  
         )  
    );  
  }  


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: Center(child: Image.asset(AppImages.splashImage),),
    );
  }
}