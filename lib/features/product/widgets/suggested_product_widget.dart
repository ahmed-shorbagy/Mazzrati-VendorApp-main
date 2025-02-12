import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/features/barcode/controllers/barcode_controller.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/suggested_product.dart';
import 'package:mazzraati_vendor_app/helper/price_converter.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/features/product/controllers/product_controller.dart';
import 'package:mazzraati_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/main.dart';
import 'package:mazzraati_vendor_app/utill/app_constants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/image_diaglog_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/screens/add_product_screen.dart';

class SuggestedProductWidget extends StatefulWidget {
  final Product? productModel;
  final bool isDetails;
  const SuggestedProductWidget(
      {super.key, required this.productModel, this.isDetails = false});

  @override
  State<SuggestedProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<SuggestedProductWidget> {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  var speedDialDirection =
      Provider.of<LocalizationController>(Get.context!, listen: false).isLtr
          ? SpeedDialDirection.left
          : SpeedDialDirection.right;
  var buttonSize = const Size(35.0, 35.0);
  var childrenButtonSize = const Size(45.0, 45.0);

  @override
  Widget build(BuildContext context) {
    String? baseUrl = Provider.of<SplashController>(context, listen: false)
        .baseUrls!
        .productImageUrl;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: GestureDetector(
            onTap: widget.isDetails
                ? null
                : () {
                    //ToDO: Navigate to  Add Product Screen
                    log("================================================");
                    log("================================================1");
                    log("================================================2");
                    AppConstants.logWithColor(
                        widget.productModel!.toJson().toString(),
                        AppConstants.red);
                    log("================================================4");
                    log("================================================15");
                    log("================================================26");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProductScreen(
                                isFromSuggestion: true,
                                product: widget.productModel)));
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (_) => ProductDetailsScreen(
                    //           productModel: widget.productModel)));
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeMedium,
                  vertical: Dimensions.paddingSizeSmall),
              decoration:
                  BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 2))
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeSmall),
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.10),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall),
                                ),
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.paddingSizeSmall),
                                    child: CustomImageWidget(
                                        image:
                                            '${widget.productModel?.thumbnailFullUrl!.path}'))),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),
                            widget.isDetails
                                ? const SizedBox()
                                : Text(
                                    getTranslated(
                                        widget.productModel?.productType,
                                        context)!,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: Provider.of<LocalizationController>(
                                              context,
                                              listen: false)
                                          .isLtr
                                      ? 30
                                      : 0,
                                  left: Provider.of<LocalizationController>(
                                              context,
                                              listen: false)
                                          .isLtr
                                      ? 0
                                      : 30,
                                ),
                                child: Text(widget.productModel!.name ?? '',
                                    style: robotoRegular.copyWith(
                                        color:
                                            ColorResources.titleColor(context)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              // Container(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: Dimensions.paddingSizeSmall,
                              //         vertical:
                              //             Dimensions.paddingSizeExtraSmall),
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(
                              //             Dimensions.paddingSizeExtraSmall),
                              //         color: widget.productModel!
                              //                     .requestStatus ==
                              //                 0
                              //             ? ColorResources.colombiaBlue
                              //             : widget.productModel!
                              //                         .requestStatus ==
                              //                     1
                              //                 ? ColorResources.green
                              //                 : ColorResources.getRed(context)),
                              //     child: Text(
                              //         widget.productModel!.requestStatus == 0
                              //             ? '${getTranslated('new_request', context)}'
                              //             : widget.productModel!
                              //                         .requestStatus ==
                              //                     1
                              //                 ? '${getTranslated('approved', context)}'
                              //                 : '${getTranslated('denied', context)}',
                              //         style: robotoRegular.copyWith(
                              //             color: Colors.white),
                              //         maxLines: 1,
                              //         overflow: TextOverflow.ellipsis)),
                              // const SizedBox(
                              //     height: Dimensions.paddingSizeSmall),
                              widget.isDetails
                                  ? SizedBox(
                                      height: Dimensions.productImageSize,
                                      child: ListView.builder(
                                          itemCount: widget
                                              .productModel!.images!.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return ImageDialogWidget(
                                                          imageUrl:
                                                              '$baseUrl/${widget.productModel!.images![index]}');
                                                    });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                    ),
                                                    width: Dimensions
                                                        .productImageSize,
                                                    height:
                                                        Dimensions.imageSize,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .paddingSizeExtraSmall),
                                                      child: CustomImageWidget(
                                                        image: widget
                                                            .productModel!
                                                            .imagesFullUrl![
                                                                index]
                                                            .path!,
                                                        width: Dimensions
                                                            .productImageSize,
                                                        height: Dimensions
                                                            .productImageSize,
                                                      ),
                                                    )),
                                              ),
                                            );
                                          }),
                                    )
                                  : Column(
                                      children: [
                                        Row(children: [
                                          Text(
                                            '${getTranslated('selling_price', context)} : ',
                                            style: robotoRegular.copyWith(
                                                color: Theme.of(context)
                                                    .hintColor),
                                          ),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  context,
                                                  widget
                                                      .productModel!.unitPrice,
                                                  discountType: widget
                                                      .productModel!
                                                      .discountType,
                                                  discount: widget
                                                      .productModel!.discount),
                                              style: robotoMedium.copyWith(
                                                  color:
                                                      ColorResources.titleColor(
                                                          context)))
                                        ]),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.isDetails && widget.productModel!.deniedNote != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraSmall),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${getTranslated('note', context)}: ',
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context).primaryColor)),
                              Expanded(
                                  child: Text(widget.productModel!.deniedNote!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 50,
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeDefault))),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
        extend
            ? Align(
                alignment:
                    Provider.of<LocalizationController>(context, listen: false)
                            .isLtr
                        ? Alignment.topRight
                        : Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      width: 205,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).hintColor,
                                spreadRadius: .1,
                                blurRadius: .2,
                                offset: Offset.fromDirection(2, 1))
                          ],
                          borderRadius: BorderRadius.circular(
                              Dimensions.iconSizeExtraLarge))),
                ))
            : const SizedBox(),
      ],
    );
  }
}
