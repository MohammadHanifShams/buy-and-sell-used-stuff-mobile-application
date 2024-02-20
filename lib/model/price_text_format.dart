import 'package:buy_and_sell_used_stuff_mobile_application/model/product.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceTextFormat extends StatelessWidget {
  const PriceTextFormat({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text:'قیمت: ${NumberFormat(/*'#,### ',*/ '', 'fa').format(product.price)}',
        style: TextStyle(
          color: Theme.of(context)
              .brightness ==
              Brightness.dark
              ? AppColors
              .priceDarkThemeColor
              : AppColors
              .priceLightThemeColor,
          fontWeight: FontWeight.bold,
          fontSize: avgDimension(20),
        ),
        children: <TextSpan>[
          TextSpan(
            text: ' \u060B', // واحد پول
            style: TextStyle(
              color: Theme.of(context)
                  .brightness ==
                  Brightness.dark
                  ? AppColors
                  .priceDarkThemeColor
                  : AppColors
                  .priceLightThemeColor,// رنگ واحد پول
              fontWeight: FontWeight.bold,
              fontSize: avgDimension(19),
            ),
          ),
        ],
      ),
    );
  }
}