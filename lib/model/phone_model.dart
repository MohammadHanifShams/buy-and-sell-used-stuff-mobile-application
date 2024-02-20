import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

String convertToInternationalFormat(String input) {
  String latinPhone = input
      .replaceAll('۰', '0')
      .replaceAll('۱', '1')
      .replaceAll('۲', '2')
      .replaceAll('۳', '3')
      .replaceAll('۴', '4')
      .replaceAll('۵', '5')
      .replaceAll('۶', '6')
      .replaceAll('۷', '7')
      .replaceAll('۸', '8')
      .replaceAll('۹', '9');

  condition() {
    if (latinPhone.startsWith('0093')) {
      return '+93${latinPhone.substring(4)}';
    }
    if (latinPhone.startsWith('0')) {
      return '+93${latinPhone.substring(1)}';
    }
    else if (!latinPhone.startsWith('+93')) {
      return '+93$latinPhone';
    }
    else {
      return latinPhone;
    }
  }

  return condition();
}

launchCaller(Uri uri) async {
  if (await canLaunchUrlString(uri.toString())) {
    await launchUrlString(uri.toString());
  } else {
    throw 'Could not launch $uri';
  }
}

GestureDetector phoneGestureDetector(
    Product product, BuildContext context) {
  return GestureDetector(
    onTap: () {
      String internationalPhone =
      convertToInternationalFormat(product.phone!);
      launchCaller(
        Uri(
          scheme: 'tel',
          path: internationalPhone,
        ),
      );
    },
    child: Text(textDirection: TextDirection.ltr,
      "${product.phone!} :✆ ",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: avgDimension(20),
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.mainOrangeColor
            : AppColors.mainOrangeColor,
      ),
    ),
  );
}