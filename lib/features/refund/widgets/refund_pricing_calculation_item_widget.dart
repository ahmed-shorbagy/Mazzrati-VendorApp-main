import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/helper/price_converter.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class ProductCalculationItemWidget extends StatelessWidget {
  final String? title;
  final double? price;
  final bool isQ;
  const ProductCalculationItemWidget(
      {super.key, this.title, this.price, this.isQ = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isQ
            ? Text('${getTranslated(title, context)} (x 1)',
                style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.titleColor(context)))
            : Text('${getTranslated(title, context)}',
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.titleColor(context))),
        const Spacer(),
        Text('-${PriceConverter.convertPrice(context, price)}',
            style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.titleColor(context))),
      ],
    );
  }
}
