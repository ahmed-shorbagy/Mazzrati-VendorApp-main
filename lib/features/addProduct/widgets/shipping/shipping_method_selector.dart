import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constrants.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';
import '../../controllers/add_product_controller.dart';

class ShippingMethodSelector extends StatelessWidget {
  const ShippingMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
      builder: (context, resProvider, _) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeExtraSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            width: .7,
            color: Theme.of(context).hintColor.withOpacity(.3),
          ),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: RadioListTile<String>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Text(
                  getTranslated('refrigerated', context)!,
                  style: robotoRegular.copyWith(fontSize: 14),
                ),
                value: 'refrigerated',
                groupValue: resProvider.shippingType,
                onChanged: (String? value) =>
                    resProvider.setShippingType(value ?? ''),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                title: Text(
                  getTranslated('non_refrigerated', context)!,
                  style: robotoRegular.copyWith(fontSize: 14),
                ),
                value: 'non_refrigerated',
                groupValue: resProvider.shippingType,
                onChanged: (String? value) =>
                    resProvider.setShippingType(value ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
