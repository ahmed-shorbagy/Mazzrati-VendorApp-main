import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../localization/language_constrants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../controllers/add_product_controller.dart';
import 'shipping/shipping_details_form.dart';
import 'shipping/shipping_method_selector.dart';

class ShippingInfoWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController shippingCapacityController;
  final TextEditingController minDeliveryLimitController;

  const ShippingInfoWidget({
    super.key,
    required this.formKey,
    required this.shippingCapacityController,
    required this.minDeliveryLimitController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
      builder: (context, resProvider, _) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[
                  Theme.of(context).brightness == Brightness.dark ? 800 : 200]!,
              spreadRadius: 0.5,
              blurRadius: 0.3,
            )
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(
                getTranslated('shipping_method', context)!,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.titleColor(context),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              const ShippingMethodSelector(),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              ShippingDetailsForm(
                shippingCapacityController: shippingCapacityController,
                minDeliveryLimitController: minDeliveryLimitController,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
            ],
          ),
        ),
      ),
    );
  }
}
