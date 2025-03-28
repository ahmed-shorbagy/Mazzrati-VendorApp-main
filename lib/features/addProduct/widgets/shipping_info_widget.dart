import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidgets/textfeild/custom_text_feild_widget.dart';
import '../../../localization/language_constrants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../controllers/add_product_controller.dart';

class ShippingInfoWidget extends StatefulWidget {
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
  State<ShippingInfoWidget> createState() => _ShippingInfoWidgetState();
}

class _ShippingInfoWidgetState extends State<ShippingInfoWidget> {
  @override
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
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(
                getTranslated('shipping_info', context)!,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: ColorResources.titleColor(context),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Type Selection
                    Text(
                      getTranslated('shipping_type', context)!,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources.titleColor(context),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          width: .7,
                          color: Theme.of(context).hintColor.withOpacity(.3),
                        ),
                        borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeExtraSmall),
                      ),
                      child: DropdownButton<String>(
                        value: resProvider.shippingType,
                        items: ['non_refrigerated', 'refrigerated']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(getTranslated(value, context)!),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            resProvider.setShippingType(value!),
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // Shipping Capacity
                    Text(
                      getTranslated('shipping_capacity', context)!,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources.titleColor(context),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    CustomTextFieldWidget(
                      border: true,
                      controller: widget.shippingCapacityController,
                      textInputType: TextInputType.number,
                      focusNode: FocusNode(),
                      textInputAction: TextInputAction.next,
                      hintText:
                          getTranslated('shipping_capacity_hint', context),
                      onChanged: (value) =>
                          resProvider.setShippingCapacity(value),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // Note about shipping charges
                    Container(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                            Dimensions.paddingSizeExtraSmall),
                      ),
                      child: Text(
                        getTranslated('shipping_charges_note', context) ??
                            'Shipping charges are configured in the shipping settings',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
            ],
          ),
        ),
      ),
    );
  }
}
