import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String? text;
  final double fontSize;
  final TextDirection? textDirection;
  final int maxLines;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  const SmallText({
    super.key,
    this.color = AppColors.smallTextColor,
    this.text,
    this.fontSize = 11,
    this.fontWeight = FontWeight.w100,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 2,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textDirection: textDirection,
      maxLines: maxLines,
      style: TextStyle(
        overflow: overflow,
        fontFamily: 'Roboto',
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
