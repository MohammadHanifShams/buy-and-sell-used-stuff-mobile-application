import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
import '../utils/colors.dart';

class TitleText extends StatelessWidget {
  final Color? color;
  final String text;
  final TextDirection? textDirection;
  final double size;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  const TitleText({
    super.key,
    this.color = AppColors.bigTextColor,
    required this.text,
    this.size = 20,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w800,
    this.overflow = TextOverflow.ellipsis,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: avgDimension(200),
      child: Text(
        text,
        maxLines: 1,
        overflow: overflow,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
