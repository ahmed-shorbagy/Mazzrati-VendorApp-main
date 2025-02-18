import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/basewidgets/textfeild/custom_text_feild_widget.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';
import '../../controllers/add_product_controller.dart';
import '../shipping_info_widget.dart';

class PriceStockSection extends StatelessWidget {
  final GlobalKey<FormState> _shippingFormKey;
  final TextEditingController _shippingCapacityController;
  final TextEditingController _minDeliveryLimitController;
  final FocusNode _discountNode;
  final FocusNode _shippingCostNode;
  final FocusNode _unitPriceNode;
  final FocusNode _totalQuantityNode;
  final FocusNode _minimumOrderQuantityNode;

  const PriceStockSection({
    super.key,
    required GlobalKey<FormState> shippingFormKey,
    required TextEditingController shippingCapacityController,
    required TextEditingController minDeliveryLimitController,
    required FocusNode discountNode,
    required FocusNode shippingCostNode,
    required FocusNode unitPriceNode,
    required FocusNode totalQuantityNode,
    required FocusNode minimumOrderQuantityNode,
  })  : _shippingFormKey = shippingFormKey,
        _shippingCapacityController = shippingCapacityController,
        _minDeliveryLimitController = minDeliveryLimitController,
        _discountNode = discountNode,
        _shippingCostNode = shippingCostNode,
        _unitPriceNode = unitPriceNode,
        _totalQuantityNode = totalQuantityNode,
        _minimumOrderQuantityNode = minimumOrderQuantityNode;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
      builder: (context, resProvider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Text(
              getTranslated('product_price_and_stock', context)!,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: ColorResources.titleColor(context),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unit Price
                Text(
                  getTranslated('unit_price', context)!,
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: ColorResources.titleColor(context),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                CustomTextFieldWidget(
                  border: true,
                  controller: resProvider.unitPriceController,
                  focusNode: _unitPriceNode,
                  nextNode: _discountNode,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.number,
                  isAmount: true,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                // Discount Section
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated('want_discount', context)!,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.titleColor(context),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                width: .7,
                                color:
                                    Theme.of(context).hintColor.withOpacity(.3),
                              ),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeExtraSmall),
                            ),
                            child: DropdownButton<bool>(
                              value: resProvider.wantDiscount,
                              items: [
                                DropdownMenuItem(
                                  value: true,
                                  child: Text(getTranslated('yes', context)!),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text(getTranslated('no', context)!),
                                ),
                              ],
                              onChanged: (value) =>
                                  resProvider.setWantDiscount(value ?? false),
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (resProvider.wantDiscount) ...[
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('discount_type', context)!,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.titleColor(context),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                  width: .7,
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(.3),
                                ),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeExtraSmall),
                              ),
                              child: DropdownButton<String>(
                                value: resProvider.discountTypeIndex == 0
                                    ? 'percent'
                                    : 'amount',
                                items: <String>['percent', 'amount']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(getTranslated(value, context)!),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  resProvider.setDiscountTypeIndex(
                                    value == 'percent' ? 0 : 1,
                                    true,
                                  );
                                },
                                isExpanded: true,
                                underline: const SizedBox(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('discount_amount', context)!,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.titleColor(context),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            CustomTextFieldWidget(
                              border: true,
                              hintText: getTranslated('discount', context),
                              controller: resProvider.discountController,
                              focusNode: _discountNode,
                              nextNode: _shippingCostNode,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.number,
                              isAmount: true,
                              onChanged: (value) {
                                resProvider.updateDiscountedPrice(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Row(
                    children: [
                      Text(
                        getTranslated('discounted_price', context)!,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.titleColor(context),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(
                        resProvider.discountedPrice,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: Dimensions.paddingSizeLarge),

                // Shipping Info
                ShippingInfoWidget(
                  formKey: _shippingFormKey,
                  shippingCapacityController: _shippingCapacityController,
                  minDeliveryLimitController: _minDeliveryLimitController,
                ),

                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
