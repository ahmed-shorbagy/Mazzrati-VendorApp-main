import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/theme/controllers/theme_controller.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';

const titilliumRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);

const titilliumSemiBold = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: Dimensions.fontSizeLarge,
  fontWeight: FontWeight.w500,
);

const titilliumBold = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w600,
);
const titilliumItalic = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: Dimensions.fontSizeDefault,
  fontStyle: FontStyle.italic,
);
const textRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w300,
  fontSize: 14,
);

const robotoHintRegular = TextStyle(
    fontFamily: 'DINNextLTArabic',
    fontWeight: FontWeight.w400,
    fontSize: Dimensions.fontSizeSmall,
    color: Colors.grey);
const robotoRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);
const robotoRegularMainHeadingAddProduct = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);

const robotoRegularForAddProductHeading = TextStyle(
  fontFamily: 'DINNextLTArabic',
  color: Color(0xFF9D9D9D),
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeSmall,
);

const robotoTitleRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeLarge,
);

const robotoSmallTitleRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeSmall,
);

const robotoBold = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w600,
);

const robotoMedium = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w500,
);

class ThemeShadow {
  static List<BoxShadow> getShadow(BuildContext context) {
    List<BoxShadow> boxShadow = [
      BoxShadow(
          color: Provider.of<ThemeController>(context, listen: false).darkTheme
              ? Colors.black26
              : Theme.of(context).primaryColor.withOpacity(.075),
          blurRadius: 5,
          spreadRadius: 1,
          offset: const Offset(1, 1))
    ];
    return boxShadow;
  }
}
