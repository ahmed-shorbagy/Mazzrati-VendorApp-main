import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:mazzraati_vendor_app/features/shipping/controllers/shipping_controller.dart';
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
  final TextEditingController _distanceFromController = TextEditingController();
  final TextEditingController _distanceToController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _distanceFromController.dispose();
    _distanceToController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<ShippingController>(context, listen: false)
        .getSelectedShippingMethodType(context);

    // Get shipping ranges from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider =
            Provider.of<ShippingController>(context, listen: false);
        provider.getShippingPrices();
      }
    });

    super.initState();
  }

  void _showAddRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(getTranslated('add_shipping_range', context) ??
            'Add Shipping Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFieldWidget(
              border: true,
              controller: _distanceFromController,
              textInputType: TextInputType.number,
              hintText: getTranslated('distance_from', context) ??
                  'Distance From (km)',
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            CustomTextFieldWidget(
              border: true,
              controller: _distanceToController,
              textInputType: TextInputType.number,
              hintText:
                  getTranslated('distance_to', context) ?? 'Distance To (km)',
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            CustomTextFieldWidget(
              border: true,
              controller: _priceController,
              textInputType: TextInputType.number,
              hintText:
                  getTranslated('shipping_price', context) ?? 'Shipping Price',
              isAmount: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getTranslated('cancel', context) ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Validate and add range
              if (_distanceFromController.text.isNotEmpty &&
                  _distanceToController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                final distanceFrom =
                    int.tryParse(_distanceFromController.text) ?? 0;
                final distanceTo =
                    int.tryParse(_distanceToController.text) ?? 0;
                final price = double.tryParse(_priceController.text) ?? 0.0;

                if (distanceFrom < distanceTo && price > 0) {
                  final success = await Provider.of<ShippingController>(context,
                          listen: false)
                      .addShippingRange(distanceFrom, distanceTo, price);

                  if (success && mounted) {
                    Navigator.pop(context); // Close add dialog
                    _distanceFromController.clear();
                    _distanceToController.clear();
                    _priceController.clear();
                  }
                }
              }
            },
            child: Text(getTranslated('add', context) ?? 'Add'),
          ),
        ],
      ),
    );
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

            // Add Range Button
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: CustomButtonWidget(
                btnTxt: getTranslated('add_shipping_range', context) ??
                    'Add Shipping Range',
                onTap: () => _showAddRangeDialog(context),
              ),
            ),

            // Shipping Ranges Display
            if (shippingProvider.isLoadingShippingPrices)
              const Padding(
                padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (shippingProvider.shippingRanges.isEmpty)
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Center(
                  child: Text(
                    getTranslated('no_shipping_ranges_found', context) ??
                        'No shipping ranges found',
                    style: robotoRegular,
                  ),
                ),
              )
            else
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
                              _buildTableCell(
                                context,
                                range.priceController.text,
                              ),
                            ],
                          );
                        }),
                      ],
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
                      onTap: () => Navigator.pop(context)),
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
