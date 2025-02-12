import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class ButtonWidgetWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final Function? callback;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double? widthFactor;
  final double? heightFactor;
  final BorderRadiusGeometry? borderRadius;
  final BoxDecoration? boxDecoration;
  final String? icon;

  const ButtonWidgetWidget({
    super.key,
    required this.text,
    this.color,
    required this.callback,
    required this.icon,
    this.textStyle,
    this.padding,
    this.widthFactor,
    this.heightFactor,
    this.borderRadius,
    this.boxDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback!();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ??
              BorderRadius.circular(Dimensions.paddingSizeSmall),
        ),
        color: color,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                  ),
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        children: [
                          Image.asset(
                            icon!,
                            width: widthFactor ??
                                MediaQuery.of(context).size.width / 20,
                            height: heightFactor ??
                                MediaQuery.of(context).size.width / 20,
                            color: ColorResources.getWhite(context),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            text!,
                            textAlign: TextAlign.center,
                            style: textStyle ??
                                robotoBold.copyWith(
                                  color: ColorResources.getWhite(context),
                                  fontSize: Dimensions.fontSizeLarge,
                                ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Provider.of<LocalizationController>(context, listen: false)
                        .isLtr
                    ? const SizedBox.shrink()
                    : const Spacer(),
                Container(
                  width: widthFactor ?? MediaQuery.of(context).size.width / 4,
                  height: heightFactor ?? MediaQuery.of(context).size.width / 7,
                  decoration: boxDecoration ??
                      BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(.10),
                        borderRadius: borderRadius ??
                            const BorderRadius.only(
                                bottomRight: Radius.circular(100)),
                      ),
                ),
                Provider.of<LocalizationController>(context, listen: false)
                        .isLtr
                    ? const Spacer()
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
