import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BackIcon extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  const BackIcon(
      {super.key,
        required this.icon,
        this.iconColor,
        this.text,
        this.backgroundColor,
        this.size= 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: avgDimension(6)),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size!/2),
        color: backgroundColor,
      ),
      child: Icon(icon, color: iconColor, size: avgDimension(20)),
    );

  }
}
