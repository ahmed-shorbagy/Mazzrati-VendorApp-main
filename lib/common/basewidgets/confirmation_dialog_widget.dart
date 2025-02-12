import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/shipping/controllers/shipping_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String icon;
  final String? title;
  final String? description;
  final Function onYesPressed;
  final Function? onNoPressed;
  final bool isLogOut;
  final bool refund;
  final Color? color;
  final bool? haveIcon;
  final TextEditingController? note;
  final String? yesButton; // Optional yes button
  final String? noButton; // Optional no button

  const ConfirmationDialogWidget({
    super.key,
    required this.icon,
    this.title,
    this.description,
    required this.onYesPressed,
    this.onNoPressed,
    this.isLogOut = false,
    this.haveIcon = true,
    this.refund = false,
    this.note,
    this.color,
    this.yesButton, // Optional in constructor
    this.noButton, // Optional in constructor
  });

  @override
  Widget build(BuildContext context) {
    // Fallback to translated text if yesButton or noButton is null
    String finalYesButton = yesButton ?? getTranslated('yes', context) ?? 'Yes';
    String finalNoButton = noButton ?? getTranslated('no', context) ?? 'No';

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            (haveIcon == true)
                ? Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Image.asset(icon, width: 50, height: 50),
                  )
                : const SizedBox(),
            title != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: color ?? Colors.red),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(
                children: [
                  Text(description ?? '',
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge),
                      textAlign: TextAlign.center),
                  refund
                      ? TextFormField(
                          controller: note,
                          decoration: InputDecoration(
                            hintText: getTranslated('note', context),
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox()
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Consumer<ShippingController>(
                builder: (context, shippingProvider, child) {
              return !shippingProvider.isLoading
                  ? Row(children: [
                      // Expanded(
                      //     child: InkWell(
                      //   splashColor: Colors.transparent,
                      //   onTap: () => onNoPressed!() ?? Navigator.pop(context),
                      //   child: CustomButtonWidget(
                      //     btnTxt: finalNoButton, // Use finalNoButton
                      //     backgroundColor: ColorResources.getHint(context),
                      //     isColor: true,
                      //   ),
                      // )),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            if (onNoPressed != null) {
                              onNoPressed!();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: CustomButtonWidget(
                            btnTxt: finalNoButton,
                            backgroundColor: ColorResources.getHint(context),
                            isColor: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSize),
                      Expanded(
                          child: CustomButtonWidget(
                        btnTxt: finalYesButton, // Use finalYesButton
                        onTap: () => onYesPressed(),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        fontSize: 14,
                      )),
                    ])
                  : const Center(child: CircularProgressIndicator());
            }),
          ]),
        ),
      ),
    );
  }
}
