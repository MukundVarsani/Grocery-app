// ignore_for_file: use_build_context_synchronously

import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Resources/auth/sign_in.dart';
import 'package:myshop/services/AuthServices/auth_method.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/widgets/global/button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final Auth auth = Auth();

  bool isCheck = false;
  bool isLoading = false;

  void userSignIn() async {
    if (_formKey.currentState!.validate()) {
      String res = "false";
      isLoading = true;
      setState(() {});

      res = await auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          name: nameController.text.trim());

      isLoading = false;

      setState(() {});
      nameController.clear();
      emailController.clear();
      passwordController.clear();

      if (res.validateEmail()) {
        VxToast.show(context, msg: "Account Created");

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SignInPage()));
      } else {
        VxToast.show(context, msg: res);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: FadedScaleAnimation(
            child: ListView(
          children: [
            Center(
              child: Image.asset(
                AppImages.leaf1,
                height: 100,
                width: 139,
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.themeColor),
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          const Text(
                            "Name",
                            style: TextStyle(
                                color: AppColors.themeColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          VxTextField(
                            controller: nameController,
                            fillColor: Colors.transparent,
                            borderColor: AppColors.themeColor,
                            borderType: VxTextFieldBorderType.roundLine,
                            borderRadius: 10,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: AppColors.themeColor,
                            ),
                            onChanged: (name) {},
                            validator: (name) {
                              if (name == null || name.isEmpty) {
                                return "Name can't be empty";
                              }
                              return null;
                            },
                          ),
                          const HeightBox(20),
                          const Text(
                            "Email",
                            style: TextStyle(
                                color: AppColors.themeColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          VxTextField(
                            controller: emailController,
                            fillColor: Colors.transparent,
                            borderColor: AppColors.themeColor,
                            borderType: VxTextFieldBorderType.roundLine,
                            borderRadius: 10,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: AppColors.themeColor,
                            ),
                            onChanged: (email) {},
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return "Email can't be empty";
                              }

                              if (!email.validateEmail()) {
                                return "Invalid Email ";
                              }
                              return null;
                            },
                          ),
                          const HeightBox(20),
                          const Text(
                            "Password",
                            style: TextStyle(
                                color: AppColors.themeColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const HeightBox(8),
                          VxTextField(
                            isPassword: true,
                            obscureText: true,
                            controller: passwordController,
                            fillColor: Colors.transparent,
                            borderColor: AppColors.themeColor,
                            borderType: VxTextFieldBorderType.roundLine,
                            borderRadius: 10,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: AppColors.themeColor,
                            ),
                            onChanged: (value) {
                              // _formKey.currentState!.validate();
                            },
                            suffixColor: AppColors.themeColor,
                            validator: (password) {
                              if (password!.isEmpty) {
                                return "password can't be empty";
                              }
                              return null;
                            },
                          ),
                          const HeightBox(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      PageTransition(
                                         alignment: Alignment.topCenter,
                                          type: PageTransitionType.scale,
                                          child: const SignInPage()));
                                },
                                child: const Text(
                                  "Have an account? Sign In",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.themeColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const HeightBox(60),
                            ],
                          ),
                          PrimaryButton(
                              title: "Submit",
                              isLoading: isLoading,
                              onPressed: userSignIn)
                        ])),
              ),
            )
          ],
        )),
      ),
    );
  }
}
