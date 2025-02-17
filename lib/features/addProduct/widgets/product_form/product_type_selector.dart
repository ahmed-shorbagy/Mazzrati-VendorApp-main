import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constrants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';
import '../../controllers/add_product_controller.dart';

class ProductTypeSelector extends StatelessWidget {
  const ProductTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
      builder: (context, resProvider, _) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTranslated('product_type', context)!,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.titleColor(context),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(
                  width: .7,
                  color: Theme.of(context).hintColor.withOpacity(.3),
                ),
                borderRadius:
                    BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: DropdownButton<int>(
                value: resProvider.productTypeIndex,
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(getTranslated('physical', context)!),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(getTranslated('digital', context)!),
                  ),
                ],
                onChanged: (value) {
                  resProvider.setProductTypeIndex(value ?? 0, true);
                },
                isExpanded: true,
                underline: const SizedBox(),
              ),
            ),
            if (resProvider.productTypeIndex == 1) ...[
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Text(
                getTranslated('digital_product_type', context)!,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.titleColor(context),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    width: .7,
                    color: Theme.of(context).hintColor.withOpacity(.3),
                  ),
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: DropdownButton<int>(
                  value: resProvider.digitalProductTypeIndex,
                  items: [
                    DropdownMenuItem(
                      value: 0,
                      child: Text(getTranslated('ready_after_sell', context)!),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(getTranslated('ready_product', context)!),
                    ),
                  ],
                  onChanged: (value) {
                    resProvider.setDigitalProductTypeIndex(value ?? 0, true);
                  },
                  isExpanded: true,
                  underline: const SizedBox(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
