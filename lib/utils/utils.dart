import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/material.dart';

class Utils {

  showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          right: 10
        ),
        backgroundColor: AppColors.mainOrangeColor,
        content: Text(
          content,
          style: const TextStyle(fontSize: 15),
          // textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(avgDimension(30)),
            topLeft: Radius.circular(avgDimension(30)),
          ),
        ),
      ),
    );
  }
}
