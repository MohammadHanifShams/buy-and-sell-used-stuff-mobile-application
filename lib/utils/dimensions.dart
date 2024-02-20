import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dimensions{
  static double screenHeight = Get.context!.height;
  static double productDetailsImageSize = screenHeight/2.41;
}
//
//   static double screenHeight = Get.context!.height;
//   static double screenWidth = Get.context!.width;
//
//   static double pageView = screenHeight/2.44;
//   static double pageViewContainer = screenHeight/3.55;
//   static double pageViewTextContainer = screenHeight/6.5;
//
//   static double height9 = screenHeight/86.78;
//   static double height10 = screenHeight/78.1;
//   static double height15 = screenHeight/52.1;
//   static double height20 = screenHeight/39;
//   static double height30 = screenHeight/26.0;
//   static double height40 = screenHeight/19.525;
//   static double height45 = screenHeight/17.4;
//
//
//   static double width10 = screenWidth/39.273;
//   static double width15 = screenWidth/26.182;
//   static double width18 = screenWidth/21.82;
//   static double width20 = screenWidth/19.64;
//   static double width30 = screenWidth/13.1;
//   static double width45 = screenWidth/8.7;
//
//   static double font20 = screenHeight/39;
//   static double font12 = screenHeight/65.1;
//
//   static double radius5 = screenHeight/156.2;
//   static double radius15 = screenHeight/52.1;
//   static double radius20 = screenHeight/39;
//   static double radius30 = screenHeight/26;
// }


class SizeConfig {
  static double screenWidth = Get.context!.width;
  static double screenHeight = Get.context!.height;

  Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}

// Get the proportionate height as per screen size
double height(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 802.91 طول صفحه که در وقت دیزاین استفاده شده
  return (inputHeight / 802.91) * screenHeight;
}

double radius(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  double screenWidth = SizeConfig.screenWidth;
  // 597.82 اوسط ارتفاع و عرض صفحه که در وقت دیزاین استفاده شده
  double avg = (screenHeight+screenWidth)/2;
  return (inputHeight / 597.82) * avg;
}

double avgDimension(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  double screenWidth = SizeConfig.screenWidth;
  // 597.82 اوسط ارتفاع و عرض صفحه که در وقت دیزاین استفاده شده
  double avg = (screenHeight+screenWidth)/2;
  return (inputHeight / 597.82) * avg;
}

double width(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 392.73 عرض صفحه که در وقت دیزاین استفاده شده
  return (inputWidth / 392.73) * screenWidth;
}


