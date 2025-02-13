import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:mazzraati_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:mazzraati_vendor_app/features/bank_info/screens/bank_info_screen.dart';
import 'package:mazzraati_vendor_app/features/product/screens/suggested_product_screen.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/features/product/controllers/product_controller.dart';
import 'package:mazzraati_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/screens/add_product_screen.dart';
import 'package:mazzraati_vendor_app/features/order/screens/order_screen.dart';
import 'package:mazzraati_vendor_app/features/shop/widgets/animated_floating_button_widget.dart';
import 'package:mazzraati_vendor_app/features/shop/widgets/shop_product_card_widget.dart';
import 'package:mazzraati_vendor_app/features/product/screens/stock_out_product_screen.dart';

class ProductViewWidget extends StatefulWidget {
  final int? sellerId;
  const ProductViewWidget({super.key, required this.sellerId});

  @override
  State<ProductViewWidget> createState() => _ProductViewWidgetState();
}

class _ProductViewWidgetState extends State<ProductViewWidget> {
  ScrollController scrollController = ScrollController();
  String message = "";
  bool activated = false;
  bool endScroll = false;
  _scrollListener() {
    // if (scrollController.offset >= scrollController.position.maxScrollExtent &&
    //     !scrollController.position.outOfRange) {
    //   setState(() {
    //     endScroll = true;
    //     message = "bottom";
    //     if (kDebugMode) {
    //       print('============$message=========');
    //     }
    //   });
    // } else {
    //   if (endScroll) {
    //     setState(() {
    //       endScroll = false;
    //     });
    //   }
    // }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    Provider.of<ProductController>(context, listen: false)
        .initSellerProductList(
            Provider.of<ProfileController>(context, listen: false)
                .userId
                .toString(),
            1,
            context,
            Provider.of<LocalizationController>(context, listen: false)
                        .locale
                        .languageCode ==
                    'US'
                ? 'en'
                : Provider.of<LocalizationController>(context, listen: false)
                    .locale
                    .countryCode!
                    .toLowerCase(),
            '');
    super.initState();
  }

  bool _showButtons = false;

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<ProfileController>(context, listen: false)
        .userId
        .toString();

    return Scaffold(
      floatingActionButton: _showButtons
          ? const SizedBox()
          : FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 010,
              onPressed: () {
                setState(() {
                  _showButtons = !_showButtons;
                });
              },
              child: Icon(
                _showButtons ? Icons.close : Icons.menu,
                size: 30,
              ),
            ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<ProductController>(context, listen: false)
              .initSellerProductList(
                  Provider.of<ProfileController>(context, listen: false)
                      .userId
                      .toString(),
                  1,
                  context,
                  Provider.of<LocalizationController>(context, listen: false)
                              .locale
                              .languageCode ==
                          'US'
                      ? 'en'
                      : Provider.of<LocalizationController>(context,
                              listen: false)
                          .locale
                          .countryCode!
                          .toLowerCase(),
                  '');
        },
        child: Consumer<ProductController>(
          builder: (context, prodProvider, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  prodProvider.sellerProductModel != null
                      ? (prodProvider.sellerProductModel!.products != null &&
                              prodProvider
                                  .sellerProductModel!.products!.isNotEmpty)
                          ? NotificationListener<ScrollNotification>(
                              onNotification: (scrollNotification) {
                                return false;
                              },
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: PaginatedListViewWidget(
                                  reverse: false,
                                  scrollController: scrollController,
                                  totalSize: prodProvider
                                      .sellerProductModel?.totalSize,
                                  offset:
                                      prodProvider.sellerProductModel != null
                                          ? int.parse(prodProvider
                                              .sellerProductModel!.offset
                                              .toString())
                                          : null,
                                  onPaginate: (int? offset) async {
                                    if (kDebugMode) {
                                      print('==========offset========>$offset');
                                    }
                                    await prodProvider.initSellerProductList(
                                        userId, offset!, context, 'en', '',
                                        reload: false);
                                  },
                                  itemView: ListView.builder(
                                    itemCount: prodProvider
                                        .sellerProductModel!.products!.length,
                                    padding: const EdgeInsets.all(0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ShopProductWidget(
                                        productModel: prodProvider
                                            .sellerProductModel!
                                            .products![index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : const NoDataScreen()
                      : const OrderShimmer(),
                  // if (!endScroll)
                  //   Positioned(
                  //     bottom: 20,
                  //     right: Provider.of<LocalizationController>(context,
                  //                 listen: false)
                  //             .isLtr
                  //         ? 20
                  //         : null,
                  //     left: Provider.of<LocalizationController>(context,
                  //                 listen: false)
                  //             .isLtr
                  //         ? null
                  //         : 20,
                  //     child: Align(
                  //       alignment: Alignment.bottomRight,
                  //       child: ScrollingFabAnimated(
                  //         width: 150,
                  //         color: Theme.of(context).cardColor,
                  //         icon: SizedBox(
                  //             width: Dimensions.iconSizeExtraLarge,
                  //             child: Image.asset(Images.addIcon)),
                  //         text: Text(
                  //           getTranslated('add_new', context)!,
                  //           style: robotoRegular.copyWith(),
                  //         ),
                  //         onPress: () async {
                  //           bool isBankInfoCompleted = await context
                  //               .read<BankInfoController>()
                  //               .isBankInfoCompleted();
                  //           if (isBankInfoCompleted) {
                  //             showDialog(
                  //                 context: context,
                  //                 builder: (BuildContext context) {
                  //                   return ConfirmationDialogWidget(
                  //                     icon: Images.addProduct,
                  //                     refund: false,
                  //                     description: getTranslated(
                  //                             'choose_product_add_type',
                  //                             context) ??
                  //                         "برجاء إختيار طريقه الإضافة",
                  //                     yesButton: getTranslated(
                  //                         'add_from_suggestions', context),
                  //                     noButton: getTranslated(
                  //                         "add_new_Product", context),
                  //                     onYesPressed: () {
                  //                       context
                  //                           .read<ProductController>()
                  //                           .getAllSuggestedProduct()
                  //                           .then((value) {
                  //                         Navigator.push(
                  //                             context,
                  //                             MaterialPageRoute(
                  //                               builder: (_) =>
                  //                                   const SuggestedProductScreen(),
                  //                             ));
                  //                       });
                  //                     },
                  //                     onNoPressed: () {
                  //                       Navigator.push(
                  //                           context,
                  //                           MaterialPageRoute(
                  //                             builder: (_) =>
                  //                                 const AddProductScreen(),
                  //                           ));
                  //                     },
                  //                   );
                  //                 });
                  //           } else {
                  //             showDialog(
                  //                 context: context,
                  //                 builder: (BuildContext context) {
                  //                   return ConfirmationDialogWidget(
                  //                     icon: Images.bankInfo,
                  //                     refund: false,
                  //                     description: getTranslated(
                  //                             'please_complete_your_bank_info_first',
                  //                             context) ??
                  //                         "يرجى اكمال معلومات البنك الخاصة بك اولا",
                  //                     yesButton: getTranslated(
                  //                         'complete_data', context),
                  //                     noButton:
                  //                         getTranslated("cancel", context),
                  //                     onYesPressed: () {
                  //                       Navigator.push(
                  //                           context,
                  //                           MaterialPageRoute(
                  //                             builder: (_) =>
                  //                                 const BankInfoScreen(),
                  //                           ));
                  //                     },
                  //                   );
                  //                 });
                  //           }
                  //         },
                  //         animateIcon: true,
                  //         inverted: false,
                  //         scrollController: scrollController,
                  //         radius: 10.0,
                  //       ),
                  //     ),
                  //   ),
                  // if (!endScroll)
                  //   Positioned(
                  //     bottom: 100,
                  //     right: Provider.of<LocalizationController>(context,
                  //                 listen: false)
                  //             .isLtr
                  //         ? 22
                  //         : null,
                  //     left: Provider.of<LocalizationController>(context,
                  //                 listen: false)
                  //             .isLtr
                  //         ? null
                  //         : 22,
                  //     child: ScrollingFabAnimated(
                  //       width: 200,
                  //       color: Theme.of(context).cardColor,
                  //       icon: SizedBox(
                  //           width: Dimensions.iconSizeExtraLarge,
                  //           child: Image.asset(Images.limitedStockIcon)),
                  //       text: Text(
                  //         getTranslated('limited_stocks', context)!,
                  //         style: robotoRegular.copyWith(),
                  //       ),
                  //       onPress: () {
                  //         Navigator.of(context).push(MaterialPageRoute(
                  //             builder: (_) => const StockOutProductScreen()));
                  //       },
                  //       animateIcon: true,
                  //       inverted: false,
                  //       scrollController: scrollController,
                  //       radius: 10.0,
                  //     ),
                  //   ),
                  //!!!!!!!!!! if (!endScroll)
                  Positioned(
                    bottom: 20,
                    right: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? 20
                        : null,
                    left: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? null
                        : 20,
                    child: Visibility(
                      visible: _showButtons,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ScrollingFabAnimated(
                          width: 60,
                          color: Theme.of(context).cardColor,
                          icon: const SizedBox(
                            width: Dimensions.iconSizeExtraLarge,
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                          text: Text(
                            // getTranslated('close', context) ?? 'إغلاق القائمه',
                            "",
                            style: robotoRegular.copyWith(),
                          ),
                          onPress: () async {
                            setState(() {
                              _showButtons = !_showButtons;
                            });
                          },
                          animateIcon: true,
                          inverted: false,
                          scrollController: scrollController,
                          radius: 10.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    right: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? 20
                        : null,
                    left: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? null
                        : 20,
                    child: Visibility(
                      visible: _showButtons,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ScrollingFabAnimated(
                          width: 150,
                          color: Theme.of(context).cardColor,
                          icon: SizedBox(
                            width: Dimensions.iconSizeExtraLarge,
                            child: Image.asset(Images.addIcon),
                          ),
                          text: Text(
                            getTranslated('add_new', context)!,
                            style: robotoRegular.copyWith(),
                          ),
                          onPress: () async {
                            bool isBankInfoCompleted = await context
                                .read<BankInfoController>()
                                .isBankInfoCompleted();
                            if (isBankInfoCompleted) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationDialogWidget(
                                    icon: Images.addProduct,
                                    refund: false,
                                    haveIcon: false,
                                    description: getTranslated(
                                            'choose_product_add_type',
                                            context) ??
                                        "برجاء إختيار طريقه الإضافة",
                                    yesButton: getTranslated(
                                        'add_from_suggestions', context),
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
                                          ),
                                        );
                                      });
                                    },
                                    onNoPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const AddProductScreen(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
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
                                    yesButton:
                                        getTranslated('complete_data', context),
                                    noButton: getTranslated("cancel", context),
                                    onYesPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const BankInfoScreen(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                          animateIcon: true,
                          inverted: false,
                          scrollController: scrollController,
                          radius: 10.0,
                        ),
                      ),
                    ),
                  ),
                  //!!!!!!!!!!!   if (!endScroll)
                  Positioned(
                    bottom: 180,
                    right: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? 22
                        : null,
                    left: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? null
                        : 22,
                    child: Visibility(
                      visible: _showButtons,
                      child: ScrollingFabAnimated(
                        width: 200,
                        color: Theme.of(context).cardColor,
                        icon: SizedBox(
                          width: Dimensions.iconSizeExtraLarge,
                          child: Image.asset(Images.limitedStockIcon),
                        ),
                        text: Text(
                          getTranslated('limited_stocks', context)!,
                          style: robotoRegular.copyWith(),
                        ),
                        onPress: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const StockOutProductScreen(),
                          ));
                        },
                        animateIcon: true,
                        inverted: false,
                        scrollController: scrollController,
                        radius: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
