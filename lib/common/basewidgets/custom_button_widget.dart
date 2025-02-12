import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final bool isColor;
  final Color? backgroundColor;
  final Color? fontColor;
  final double? borderRadius;
  final double? height;
  final Border? border;
  final EdgeInsets? padding;

  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButtonWidget({
    Key? key,
    this.onTap,
    required this.btnTxt,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.isColor = false,
    this.border,
    this.height = 40,
    this.fontWeight = FontWeight.w500,
    this.fontSize = Dimensions.fontSizeLarge,
    this.fontColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap as void Function()?,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: border,
          color: isColor
              ? backgroundColor
              : backgroundColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(
            borderRadius ?? Dimensions.paddingSizeExtraSmall,
          ),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Text(
            btnTxt!,
            style: robotoMedium.copyWith(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: fontColor ?? Colors.white,
              fontFamily: 'DINNextLTArabic',
            ),
          ),
        ),
      ),
    );
  }
}
