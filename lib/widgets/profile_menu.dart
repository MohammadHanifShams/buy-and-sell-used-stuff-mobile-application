import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.iconColor = AppColors.iconColor,
  });

  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        onTap: onPress,
        leading: Container(
          width: avgDimension(40),
          height: avgDimension(40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(avgDimension(100)),
            // color: AppColors.mainColor,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: avgDimension(35),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.apply(
                color: textColor,
                fontWeightDelta: 5,
              ),
        ),
        trailing: endIcon
            ? Container(
                width: avgDimension(30),
                height: avgDimension(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(avgDimension(100)),
                  color: AppColors.greyDarkWithOpacity,
                ),
                child: Icon(
                  LineAwesomeIcons.angle_left,
                  size: avgDimension(18),
                  color: AppColors.greyLight,
                ))
            : null,
      ),
    );
  }
}
