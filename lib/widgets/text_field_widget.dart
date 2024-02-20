import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String title;
  final String? hintText;
  final TextInputType? keyboardType;
  final dynamic prefixIcon;
  final dynamic suffixIcon;
  final TextDirection? textDirection;
  final TextEditingController? controller;
  final bool obscureText;
  final bool? enableInteractiveSelection;
  final int? maxLines;
  final  GestureTapCallback? onTap;


  const TextFieldWidget({
    super.key,
    required this.title,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    required this.obscureText,
    this.textDirection,
    this.keyboardType,
    this.maxLines,
    this.enableInteractiveSelection,
    this.onTap,

  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late FocusNode focusNode;
  bool isInFocus = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isInFocus = true;
        });
      } else {
        setState(() {
          isInFocus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: avgDimension(10)),
          child: Text(
            textAlign: TextAlign.center,
            widget.title,
            style: const TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(boxShadow: [
            isInFocus
                ? BoxShadow(
                    color: Colors.white12.withOpacity(0.08),
                    blurRadius: 1,
                    spreadRadius: -1,
                  )
                : BoxShadow(
                    color: Colors.white10.withOpacity(0.04),
                    blurRadius: 1,
                    spreadRadius: -2,
                  )
          ]),
          child: TextFormField(
            keyboardType: widget.keyboardType,
            focusNode: focusNode,
            controller: widget.controller,
            obscureText: widget.obscureText,
            textDirection: widget.textDirection,
            cursorColor: Colors.orange,
            maxLines: widget.maxLines,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.inputTextDarkThemeColor
                  : AppColors.inputTextLightThemeColor,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: avgDimension(15),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              filled: true,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        )
      ],
    );
  }
}
