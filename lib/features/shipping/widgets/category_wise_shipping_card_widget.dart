import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/features/shipping/domain/models/category_wise_shipping_model.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/shipping/controllers/shipping_controller.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/theme/controllers/theme_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';

class CategoryWiseShippingCardWidget extends StatelessWidget {
  final ShippingController? shipProv;
  final Category? category;
  final int? index;

  const CategoryWiseShippingCardWidget(
      {super.key, this.shipProv, this.category, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: ColorResources.getBottomSheetColor(context),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        boxShadow: [
          BoxShadow(
              color:
                  Provider.of<ThemeController>(context, listen: false).darkTheme
                      ? Theme.of(context).primaryColor.withOpacity(0)
                      : Theme.of(context).primaryColor.withOpacity(.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.095),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                  topRight: Radius.circular(Dimensions.paddingSizeSmall))),
          child: Row(
            children: [
              Text('${index! + 1}.  ${category != null ? category!.name : ''}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
        Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(.05),
                  borderRadius: const BorderRadius.only(
                      bottomLeft:
                          Radius.circular(Dimensions.paddingSizeExtraSmall))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.iconSizeMedium),
                      child: Text(
                          '${getTranslated('cost_per_product', context)} (${Provider.of<SplashController>(context, listen: false).myCurrency!.symbol})',
                          style: robotoRegular.copyWith()),
                    ),
                    CustomTextFieldWidget(
                      border: true,
                      controller: shipProv!.shippingCostController[index!],
                      focusNode: shipProv!.shippingCostNode[index!],
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      isAmount: true,
                      // isAmount: true,
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeMedium,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                      bottomRight:
                          Radius.circular(Dimensions.paddingSizeExtraSmall))),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraLarge),
                      child: Text(
                          '${getTranslated('multiply_with_qty', context)}',
                          style: robotoRegular.copyWith()),
                    ),
                    FlutterSwitch(
                      width: 40,
                      height: 20,
                      toggleSize: 16,
                      padding: 2,
                      value: shipProv!.isMultiply[index!],
                      onToggle: (value) {
                        shipProv!.toggleMultiply(context, value, index!);
                      },
                    ),
                    const SizedBox(height: 42)
                  ]),
            ),
          ),
        ]),
      ]),
    );
  }
}
