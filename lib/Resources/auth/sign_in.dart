// ignore_for_file: use_build_context_synchronously

import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshop/Admin/admin_navigation_bar.dart';
import 'package:myshop/Resources/auth/sign_up.dart';
import 'package:myshop/pages/user_navigation_bar.dart';
import 'package:myshop/services/AuthServices/auth_method.dart';
import 'package:myshop/services/Provider/user_provider.dart';
import 'package:myshop/bloc/AuthBloc/LoginCubit/login_cubit.dart';
import 'package:myshop/utils/colors.dart';
import 'package:myshop/utils/images.dart';
import 'package:myshop/widgets/global/button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc/AuthBloc/LoginCubit/login_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Auth _auth = Auth();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isAdmin = false;

  void userSign() async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<LoginCubit>(context).loginStatus(context,
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    }
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
                              "Login",
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
                            suffixColor: AppColors.themeColor,
                            validator: (password) {
                              if (password!.isEmpty) {
                                return "password can't be empty";
                              }
                              return null;
                            },
                          ),
                          const HeightBox(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 210,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          PageTransition(
                                            alignment: Alignment.topCenter ,

                                              type: PageTransitionType.rotate,
                                              child: const SignUpPage()));
                                    },
                                    child: const Text(
                                      "Don't Have an account? Sign Up",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.themeColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )),
                              InkWell(
                                onTap: () {
                                  _auth.forgetPassword(
                                      "varsanimukund56@gmail.com");
                                },
                                child: const Text(
                                  'Forget Password',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.themeColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const HeightBox(60),
                            ],
                          ),
                          BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) async {
                              if (state is LoginLoadedState) {
                                UserProvider userProvider =
                                    Provider.of<UserProvider>(context,
                                        listen: false);

                                isAdmin =
                                    userProvider.getCurrentUser?.role == 'Admin'
                                        ? true
                                        : false;

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => isAdmin
                                        ? const AdminNavigationBar()
                                        : const UserNavigationBar(),
                                  ),
                                );

                                emailController.clear();
                                passwordController.clear();
                                VxToast.show(context,
                                    msg: "Welcome ${state.name}");
                              } else if (state is LoginErrorState) {
                                VxToast.show(context, msg: state.error);
                              }
                            },
                            builder: (context, state) {
                              bool isLoading = state is LoginLoadingState;
                              return PrimaryButton(
                                  title: "Submit",
                                  isLoading: isLoading,
                                  onPressed: () {
                                    userSign();
                                  });
                            },
                          )
                        ])),
              ),
            )
          ],
        )),
      ),
    );
  }
}
