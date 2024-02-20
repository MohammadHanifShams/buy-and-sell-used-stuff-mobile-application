import 'dart:ui';

import 'package:buy_and_sell_used_stuff_mobile_application/main.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/sign_in_page/social_card.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/sign_up_page/Sign_up_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/resources/authentication_methods.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/utils.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/customized_actionChip_button.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/logo_widget.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthenticationMethods authenticationMethods = AuthenticationMethods();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
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
          Image.asset('assets/image/sign_in_background.png', fit: BoxFit.cover),
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
                          height: avgDimension(750),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: avgDimension(55),
                              ),
                              const LogoWidget(),
                              SizedBox(
                                height: avgDimension(300),
                                width: avgDimension(290),
                                child: IntrinsicHeight(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: avgDimension(20),
                                      ),
                                      TextFieldWidget(
                                        title: "ایمیل",
                                        hintText: "ایمیل خود را وارد نمایید",
                                        controller: emailController,
                                        obscureText: false,
                                        maxLines: 1,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      SizedBox(
                                        height: avgDimension(20),
                                      ),
                                      TextFieldWidget(
                                        title: "پسورد",
                                        hintText: "رمز عبور خود را وارد نمایید",
                                        controller: passwordController,
                                        obscureText: true,
                                        maxLines: 1,
                                      ),
                                      SizedBox(
                                        height: avgDimension(50),
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
                                          Future.delayed(
                                            const Duration(seconds: 1),
                                          );
                                          String output =
                                              await authenticationMethods
                                                  .signInUser(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (output == "Success") {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return const Home();
                                                },
                                              ),
                                            );
                                          } else {
                                            Utils().showSnackBar(
                                              context: context,
                                              content: output,
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "ورود",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.6,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: avgDimension(30),
                              ),
                              SizedBox(
                                width: 300,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Colors.brown,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: avgDimension(5),
                                      ),
                                      child: const Text(
                                        "OR",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: avgDimension(30),
                              ),
                              Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "حساب کاربری ندارید؟",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const SignUpScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "ایجاد حساب جدید",
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: avgDimension(30),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SocialCard(
                                    icon: "assets/icons/google-icon.svg",
                                    press: () {},
                                  ),
                                  SocialCard(
                                    icon: "assets/icons/facebook.svg",
                                    press: () {},
                                  ),
                                  SocialCard(
                                    icon: "assets/icons/twitter.svg",
                                    press: () {},
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
