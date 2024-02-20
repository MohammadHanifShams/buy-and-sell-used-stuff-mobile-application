import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x0adddddd),
          borderRadius: BorderRadius.circular(avgDimension(100)),
          border: Border.all(color: Colors.orange),
        ),
        child: Image(
          image: const AssetImage("assets/image/Logo.png"),
          height: avgDimension(160),
        ),
      ),
    );
  }
}