import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constrants.dart';
import '../../../../utill/dimensions.dart';
import '../../controllers/add_product_controller.dart';

class ShippingMethodSelector extends StatelessWidget {
  const ShippingMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
      builder: (context, resProvider, _) => Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            width: .7,
            color: Theme.of(context).hintColor.withOpacity(.3),
          ),
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
        child: Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text(getTranslated('refrigerated', context)!),
                value: 'refrigerated',
                groupValue: resProvider.shippingType,
                onChanged: (String? value) =>
                    resProvider.setShippingType(value ?? ''),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text(getTranslated('non_refrigerated', context)!),
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
