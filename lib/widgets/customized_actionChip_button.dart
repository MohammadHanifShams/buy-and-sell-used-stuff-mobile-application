
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomizedButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final bool isLoading;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final dynamic fixedSize;

  const CustomizedButton({
    super.key,
    required this.child,
    this.color,
    required this.isLoading,
    required this.onPressed,
    this.padding,
    this.fixedSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        fixedSize: fixedSize,
        // fixedSize: Size(
        //   screenSize.width * avgDimension(0.4),
        //   avgDimension(50),
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(avgDimension(15)),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      child: !isLoading
          ? child
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: SpinKitSpinningLines(
                    color: Colors.orange,
                    size: 50.0,
                  )),
            ),
    );
  }
}
