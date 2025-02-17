import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../localization/language_constrants.dart';
import '../../../../utill/dimensions.dart';

class ShippingDetailsForm extends StatelessWidget {
  final TextEditingController shippingCapacityController;
  final TextEditingController minDeliveryLimitController;

  const ShippingDetailsForm({
    super.key,
    required this.shippingCapacityController,
    required this.minDeliveryLimitController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: shippingCapacityController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: getTranslated('shipping_capacity', context),
            hintText: getTranslated('shipping_capacity_hint', context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return getTranslated('shipping_capacity_required', context);
            }
            if (int.tryParse(value) == null) {
              return getTranslated('please_enter_valid_number', context);
            }
            return null;
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        TextFormField(
          controller: minDeliveryLimitController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: getTranslated('minimum_delivery_limit', context),
            hintText: getTranslated('minimum_delivery_limit_hint', context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return getTranslated('minimum_delivery_required', context);
            }
            if (int.tryParse(value) == null) {
              return getTranslated('please_enter_valid_number', context);
            }
            final minDelivery = int.parse(value);
            final capacity = int.tryParse(shippingCapacityController.text) ?? 0;
            if (minDelivery > capacity) {
              return getTranslated(
                  'minimum_delivery_cant_be_more_than_capacity', context);
            }
            return null;
          },
        ),
      ],
    );
  }
}
