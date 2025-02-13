import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/screens/add_product_screen.dart';
import 'package:mazzraati_vendor_app/features/auction/screens/add_auction_screen.dart';
import 'package:mazzraati_vendor_app/features/auth/widgets/location_picker_screen.dart';
import 'package:mazzraati_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:mazzraati_vendor_app/features/bank_info/screens/bank_info_screen.dart';
import 'package:mazzraati_vendor_app/features/home/widgets/buttonWidget.dart';
import 'package:mazzraati_vendor_app/features/order/controllers/order_controller.dart';
import 'package:mazzraati_vendor_app/features/product/controllers/product_controller.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/features/product/screens/suggested_product_screen.dart';
import 'package:mazzraati_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/features/home/widgets/order_type_button_head_widget.dart';

class OngoingOrderWidget extends StatelessWidget {
  final Function? callback;
  const OngoingOrderWidget({super.key, this.callback});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(builder: (context, order, child) {
      return Consumer<BankInfoController>(
        builder: (context, bankInfoController, child) {
          return Container(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                    color: ColorResources.getPrimary(context).withOpacity(.05),
                    spreadRadius: -3,
                    blurRadius: 12,
                    offset: Offset.fromDirection(0, 6))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),
                // CustomButtonWidget(
                //   btnTxt: 'location',
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const LocationPicker()));
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeMedium),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container(
                      //     width: Dimensions.iconSizeLarge,
                      //     height: Dimensions.iconSizeLarge,
                      //     padding: const EdgeInsets.only(
                      //         left: Dimensions.paddingSizeExtraSmall),
                      //     child: Image.asset(Images.monthlyEarning)),
                      // const SizedBox(
                      //   width: Dimensions.paddingSizeSmall,
                      // ),
                      order.isAddButtonClicked
                          ? const Expanded(
                              child: Center(
                              child: CircularProgressIndicator(),
                            ))
                          : Expanded(
                              child: ButtonWidgetWidget(
                                callback: () async {
                                  order.changeIsAddButtonClicked(true);
                                  context
                                      .read<ProfileController>()
                                      .getSellerInfo();
                                  log(context
                                      .read<ProfileController>()
                                      .userInfoModel!
                                      .authToken
                                      .toString());
                                  bool isBankInfoCompleted = await context
                                      .read<BankInfoController>()
                                      .isBankInfoCompleted();

                                  if (isBankInfoCompleted) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ConfirmationDialogWidget(
                                            icon: Images.addProduct,
                                            haveIcon: false,
                                            refund: false,
                                            description: getTranslated(
                                                    'choose_product_add_type',
                                                    context) ??
                                                "برجاء إختيار طريقه الإضافة",
                                            yesButton: getTranslated(
                                                'add_from_suggestions',
                                                context),
                                            noButton: getTranslated(
                                                "add_new_Product", context),
                                            onYesPressed: () {
                                              context
                                                  .read<ProductController>()
                                                  .getAllSuggestedProduct()
                                                  .then((value) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const SuggestedProductScreen(),
                                                    ));
                                              });
                                            },
                                            onNoPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const AddProductScreen(),
                                                  ));
                                            },
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ConfirmationDialogWidget(
                                            icon: Images.bankInfo,
                                            refund: false,
                                            description: getTranslated(
                                                    'please_complete_your_bank_info_first',
                                                    context) ??
                                                "يرجى اكمال معلومات البنك الخاصة بك اولا",
                                            yesButton: getTranslated(
                                                'complete_data', context),
                                            noButton: getTranslated(
                                                "cancel", context),
                                            onYesPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const BankInfoScreen(
                                                      isFromMain: true,
                                                    ),
                                                  ));
                                            },
                                          );
                                        });
                                  }
                                  order.changeIsAddButtonClicked(false);
                                },
                                text:
                                    getTranslated('add_product', context) ?? '',
                                color:
                                    ColorResources.addProdutCardColor(context),
                                icon: Images.addIcon,
                              ),
                            ),
                      // CustomButtonWidget(
                      //   btnTxt: getTranslated('add_product', context) ?? '',
                      //   height: 45,
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: Dimensions.paddingSizeMedium),
                      //   onTap: () => Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (_) => const AddProductScreen())),
                      // ),

                      // Text(getTranslated('business_analytics', context)!, style: robotoBold.copyWith(
                      //     color: ColorResources.getTextColor(context),
                      //     fontSize: Dimensions.fontSizeDefault),),

                      Expanded(
                        child: ButtonWidgetWidget(
                          icon: Images.auction,
                          callback: () {
                            Provider.of<AddProductController>(context,
                                    listen: false)
                                .getCategoryList(context, null, 'en');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddAuctionScreen()));
                          },
                          text: getTranslated('create_auction', context) ?? '',
                          color: ColorResources.addAuctionCardColor(context),
                        ),
                      ),
                      // CustomButtonWidget(
                      //   btnTxt: getTranslated('create_auction', context) ?? '',
                      //   height: 45,
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: Dimensions.paddingSizeMedium),
                      //   onTap: () => Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (_) => const AddAuctionScreen())),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Dimensions.paddingSizeSmall,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeDefault,
                      Dimensions.paddingSizeExtraSmall,
                      Dimensions.paddingSizeDefault,
                      Dimensions.paddingSeven),
                  child: Text(
                    getTranslated('on_going_orders', context)!,
                    style: robotoBold.copyWith(
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                order.orderModel != null
                    ? Consumer<BankInfoController>(
                        builder: (context, bankInfoController, child) =>
                            Padding(
                          padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeSmall,
                              0,
                              Dimensions.paddingSizeSmall,
                              Dimensions.fontSizeSmall),
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: (1 / .65),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              OrderTypeButtonHeadWidget(
                                color:
                                    ColorResources.firstTwoCardColor(context),
                                text: getTranslated('pending_orders', context),
                                index: 1,
                                subText: '',
                                numberOfOrder: bankInfoController
                                    .businessAnalyticsFilterData?.pending,
                                callback: callback,
                                icon: Images.waitingOrders,
                                heightFactor: 40,
                                widthFactor: 40,
                              ),
                              // OrderTypeButtonHeadWidget(
                              //   // color: ColorResources.mainCardTwoColor(context),
                              //   color: ColorResources.mainCardOneColor(context),
                              //   text: getTranslated('processing', context),
                              //   index: 2,
                              //   numberOfOrder: bankInfoController
                              //       .businessAnalyticsFilterData?.processing,
                              //   callback: callback,
                              //   subText: '',
                              // ),
                              OrderTypeButtonHeadWidget(
                                // color:
                                //     ColorResources.mainCardThreeColor(context),
                                color:
                                    ColorResources.firstTwoCardColor(context),
                                text: getTranslated('confirmed_order', context),
                                index: 7,
                                subText: '',
                                numberOfOrder: bankInfoController
                                    .businessAnalyticsFilterData?.confirmed,
                                callback: callback,
                                icon: Images.acceptedOrders,
                                heightFactor: 40,
                                widthFactor: 40,
                              ),
                              // OrderTypeButtonHeadWidget(
                              //   // color:
                              //   //     ColorResources.mainCardFourColor(context),
                              //   color: ColorResources.mainCardOneColor(context),
                              //   text:
                              //       getTranslated('out_for_delivery', context),
                              //   index: 8,
                              //   subText: '',
                              //   numberOfOrder: bankInfoController
                              //       .businessAnalyticsFilterData
                              //       ?.outForDelivery,
                              //   callback: callback,
                              // ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 150,
                        child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).primaryColor)))),
                order.orderModel != null
                    ? Consumer<BankInfoController>(
                        builder: (context, bankInfoController, child) =>
                            Padding(
                          padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeSmall,
                              0,
                              Dimensions.paddingSizeSmall,
                              Dimensions.fontSizeSmall),
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 1,
                            childAspectRatio: (1 / (.65 / 2)),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              //!!!!!!!!!!!!!!!!!! Out For Delivery !!!!!!!!!!!!!!!!!!
                              OrderTypeButtonHeadWidget(
                                // color:
                                //     ColorResources.mainCardFourColor(context),
                                color: ColorResources.lastCardColor(context),
                                text: getTranslated(
                                    'out_for_delivery_order', context),
                                index: 8,
                                subText: '',
                                icon: Images.shippingOrders,
                                heightFactor: 40,
                                widthFactor: 40,
                                numberOfOrder: bankInfoController
                                    .businessAnalyticsFilterData
                                    ?.outForDelivery,
                                callback: callback,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 150,
                        child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).primaryColor)))),
                const SizedBox(height: Dimensions.paddingSizeSmall),
              ],
            ),
          );
        },
      );
    });
  }
}
