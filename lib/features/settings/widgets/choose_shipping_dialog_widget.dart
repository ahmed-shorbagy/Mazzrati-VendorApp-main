import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:mazzraati_vendor_app/features/shipping/controllers/shipping_controller.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class ChooseShippingDialogWidget extends StatefulWidget {
  const ChooseShippingDialogWidget({super.key});

  @override
  State<ChooseShippingDialogWidget> createState() =>
      _ChooseShippingDialogWidgetState();
}

class _ChooseShippingDialogWidgetState
    extends State<ChooseShippingDialogWidget> {
  @override
  void initState() {
    Provider.of<ShippingController>(context, listen: false)
        .getSelectedShippingMethodType(context);

    // Call the API to get shipping prices
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider =
            Provider.of<ShippingController>(context, listen: false);
        provider.getShippingPrices();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Theme.of(context).cardColor,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      backgroundColor: Theme.of(context).highlightColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child:
            Consumer<ShippingController>(builder: (cont, shippingProvider, _) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeExtraLarge,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeSmall),
              child: Text(getTranslated('choose_shipping', context)!,
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: Text(getTranslated('select_shipping_method', context)!,
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall)),
            ),

            // API Response Display
            if (shippingProvider.isLoadingShippingPrices)
              const Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (shippingProvider.shippingPricesResponse != null)
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Response:',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: ColorResources.titleColor(context),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        border: Border.all(
                          color: Theme.of(context).hintColor.withOpacity(.3),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        shippingProvider.shippingPricesResponse.toString(),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Shipping Ranges Table
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated('shipping_charges_by_distance', context) ??
                        'Shipping Charges by Distance',
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: ColorResources.titleColor(context),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  if (shippingProvider.shippingRanges.isNotEmpty)
                    Table(
                      border: TableBorder.all(
                        color: Theme.of(context).hintColor.withOpacity(.3),
                        width: 0.7,
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                          children: [
                            _buildTableHeader(
                                context,
                                getTranslated('distance_range', context) ??
                                    'Distance Range'),
                            _buildTableHeader(
                                context,
                                getTranslated('shipping_cost', context) ??
                                    'Shipping Cost'),
                          ],
                        ),
                        ...shippingProvider.shippingRanges.map((range) {
                          return TableRow(
                            children: [
                              _buildTableCell(
                                context,
                                '${range.startKm} - ${range.endKm == -1 ? '∞' : range.endKm} ${getTranslated('km', context) ?? 'km'}',
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CustomTextFieldWidget(
                                  border: true,
                                  controller: range.priceController,
                                  textInputType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  isAmount: true,
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    )
                  else
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text(
                          getTranslated(
                                  'initializing_shipping_ranges', context) ??
                              'Initializing shipping ranges...',
                          style: robotoRegular,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(children: [
                Expanded(
                  child: CustomButtonWidget(
                      fontColor: ColorResources.getTextColor(context),
                      btnTxt: getTranslated('cancel', context),
                      backgroundColor:
                          Theme.of(context).hintColor.withOpacity(.5),
                      onTap: () => Navigator.pop(context)),
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeDefault,
                ),
                Expanded(
                  child: CustomButtonWidget(
                      fontColor: Colors.white,
                      btnTxt: getTranslated('update', context),
                      onTap: () {
                        String? type;
                        if (shippingProvider.shippingIndex == 0) {
                          type = 'order_wise';
                        } else if (shippingProvider.shippingIndex == 1) {
                          type = 'product_wise';
                        } else if (shippingProvider.shippingIndex == 2) {
                          type = 'category_wise';
                        }

                        // Save shipping ranges
                        // In future, this would be sent to the API
                        Map<String, dynamic> shippingRanges =
                            shippingProvider.getShippingRangesJson();
                        print('Shipping Ranges: $shippingRanges');

                        shippingProvider
                            .setShippingMethodType(context, type)
                            .then((value) {
                          if (value.response!.statusCode == 200) {
                            Provider.of<SplashController>(context,
                                    listen: false)
                                .initConfig();
                            Navigator.pop(context);
                          }
                        });
                      }),
                ),
              ]),
            ),
          ]);
        }),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: robotoMedium.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: ColorResources.titleColor(context),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: ColorResources.titleColor(context),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
