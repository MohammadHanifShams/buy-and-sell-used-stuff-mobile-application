import 'dart:ui';

import 'package:buy_and_sell_used_stuff_mobile_application/pages/sign_in_page/Sign_in_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/resources/authentication_methods.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/customized_actionChip_button.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/logo_widget.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AuthenticationMethods authenticationMethods = AuthenticationMethods();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    displayNameController.dispose();
    addressController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = SizeConfig().getScreenSize(context);
    return SizedBox(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/image/sign_in_background.png',
            fit: BoxFit.cover,
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0x15000000),
                  ),
                  child: IntrinsicHeight(
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SingleChildScrollView(
                        child: SizedBox(
                          height: avgDimension(755),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: avgDimension(15),
                              ),
                              const LogoWidget(),
                              SizedBox(
                                width: avgDimension(290),
                                child: IntrinsicHeight(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: avgDimension(5),
                                      ),
                                      TextFieldWidget(
                                        title: "نام کاربری",
                                        hintText: "نام خود را وارد نمایید",
                                        controller: displayNameController,
                                        maxLines: 1,
                                        obscureText: false,
                                      ),
                                      SizedBox(
                                        height: avgDimension(5),
                                      ),
                                      TextFieldWidget(
                                        title: "آدرس",
                                        hintText: "ایمیل خود را وارد نمایید",
                                        controller: addressController,
                                        maxLines: 1,
                                        obscureText: false,
                                      ),
                                      SizedBox(
                                        height: avgDimension(5),
                                      ),
                                      TextFieldWidget(
                                        title: "ایمیل",
                                        hintText: "ایمیل خود را وارد نمایید",
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        maxLines: 1,
                                        obscureText: false,
                                      ),
                                      SizedBox(
                                        height: avgDimension(5),
                                      ),
                                      TextFieldWidget(
                                        title: "رمز عبور",
                                        hintText: "رمز عبور خود را وارد نمایید",
                                        controller: passwordController,
                                        maxLines: 1,
                                        obscureText: true,
                                      ),
                                      SizedBox(
                                        height: avgDimension(5),
                                      ),
                                      TextFieldWidget(
                                        title: "تایید رمز عبور",
                                        hintText:
                                            "رمز عبور خود را دوباره وارد نمایید",
                                        controller: confirmPasswordController,
                                        maxLines: 1,
                                        obscureText: true,
                                      ),
                                      SizedBox(
                                        height: avgDimension(20),
                                      ),
                                      CustomizedButton(
                                        fixedSize: Size(
                                          screenSize.width * avgDimension(0.4),
                                          avgDimension(40),
                                        ),
                                        color: AppColors.mainColor3,
                                        isLoading: isLoading,
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          String output =
                                              await authenticationMethods
                                                  .signUpUser(
                                            displayName:
                                                displayNameController.text,
                                            address: addressController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            confirmPassword:
                                                confirmPasswordController.text,
                                            context: context,
                                          );

                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (output ==
                                              "ثبت نام با موفقیت انجام شد") {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignInScreen(),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "ثبت نام",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.6,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: avgDimension(20),
                              ),
                              Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "از قبل حساب کاربری دارید؟",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const SignInScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      " به حساب خود وارد شوید.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
