import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/features/order/controllers/order_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class OrderTypeButtonHeadWidget extends StatelessWidget {
  final String? text;
  final String? subText;
  final Color? color;
  final int index;
  final Function? callback;
  final int? numberOfOrder;
  final String? icon;
  final double? widthFactor;
  final double? heightFactor;
  const OrderTypeButtonHeadWidget(
      {super.key,
      required this.text,
      this.subText,
      this.color,
      required this.index,
      required this.callback,
      required this.numberOfOrder,
      this.icon,
      this.widthFactor,
      this.heightFactor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<OrderController>(context, listen: false)
            .setIndex(context, index);
        callback!();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        color: color,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge),
              child: Container(
                  alignment: Alignment.center,
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(numberOfOrder.toString(),
                              style: robotoBold.copyWith(
                                  color: ColorResources.getWhite(context),
                                  fontSize: Dimensions.fontSizeHeaderLarge)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(text!,
                              style: robotoRegular.copyWith(
                                  color: ColorResources.getWhite(context),
                                  fontSize: Dimensions.fontSizeSmall)),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Text(subText!,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: ColorResources.getWhite(context))),
                        ],
                      ),
                    ],
                  ))),
            ),
            Row(
              children: [
                Provider.of<LocalizationController>(context, listen: false)
                        .isLtr
                    ? const SizedBox.shrink()
                    : const Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 4,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(.10),
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(100))),
                ),
                Provider.of<LocalizationController>(context, listen: false)
                        .isLtr
                    ? const Spacer()
                    : const SizedBox.shrink(),
              ],
            ),
            Positioned(
              left: Dimensions.paddingSizeMedium,
              top: Dimensions.paddingSizeMedium,
              child: Image.asset(
                color: Colors.white,
                icon!,
                width: widthFactor ?? MediaQuery.of(context).size.width / 18,
                height: heightFactor ?? MediaQuery.of(context).size.width / 18,
                // color: ColorResources.getWhite(context),
              ),
            ),
            const SizedBox(
              width: Dimensions.paddingSizeSmall,
            ),
          ],
        ),
      ),
    );
  }
}
