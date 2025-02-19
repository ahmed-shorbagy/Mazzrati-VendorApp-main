import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/features/product_details/controllers/productDetailsController.dart';
import 'package:mazzraati_vendor_app/features/product_details/widgets/product_details_review_widget.dart';
import 'package:mazzraati_vendor_app/features/product_details/widgets/product_details_widget.dart';
import 'package:mazzraati_vendor_app/features/review/controllers/product_review_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/theme/controllers/theme_controller.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product? productModel;
  const ProductDetailsScreen({super.key, this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isLocalActive = false;
  bool _isFirstLoad = true;

  void load(BuildContext context) {
    Provider.of<ProductReviewController>(context, listen: false)
        .getProductWiseReviewList(context, 1, widget.productModel!.id);
    Provider.of<ProductDetailsController>(context, listen: false)
        .getProductDetails(widget.productModel!.id);
    Provider.of<AddProductController>(context, listen: false)
        .getCategoryList(context, null, 'en');
  }

  @override
  void initState() {
    super.initState();
    load(context);
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController?.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: getTranslated('product_details', context),
          isBackButtonExist: true,
          isSwitch: false,
          isAction: true,
          productSwitch: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _isFirstLoad = true;
            load(context);
          },
          child: Consumer<ProductDetailsController>(
            builder: (context, productDetailsProvider, _) {
              // Initialize local state from API response only on first load
              if (_isFirstLoad &&
                  productDetailsProvider.productDetails != null) {
                _isLocalActive =
                    productDetailsProvider.productDetails?.requestStatus == 1;
                _isFirstLoad = false;
              }

              return Column(children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[
                            Provider.of<ThemeController>(context).darkTheme
                                ? 800
                                : 200]!,
                        spreadRadius: 0.5,
                        blurRadius: 0.3,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('product_status', context)!,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _isLocalActive
                                  ? getTranslated('product_active', context)!
                                  : getTranslated('product_inactive', context)!,
                              style: robotoRegular.copyWith(
                                color: _isLocalActive
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isLocalActive,
                        onChanged: productDetailsProvider.isLoading
                            ? null // Disable switch while loading
                            : (value) {
                                // Update local state immediately for responsive UI
                                setState(() {
                                  _isLocalActive = value;
                                });

                                // Then perform the API call
                                productDetailsProvider
                                    .productStatusOnOff(
                                  context,
                                  widget.productModel!.id,
                                  value ? 1 : 0,
                                )
                                    .then((_) {
                                  // If the API call fails, revert to the previous state
                                  if (productDetailsProvider
                                          .productDetails?.requestStatus !=
                                      (value ? 1 : 0)) {
                                    setState(() {
                                      _isLocalActive = !value;
                                    });
                                  }
                                });
                              },
                        activeColor: Theme.of(context).primaryColor,
                        activeTrackColor:
                            Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      if (productDetailsProvider.isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).cardColor,
                    child: TabBar(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraLarge),
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).hintColor,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 1,
                      isScrollable: true,
                      unselectedLabelStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.w400,
                      ),
                      labelStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: [
                        Tab(text: getTranslated("product_details", context)),
                        Tab(text: getTranslated("reviews", context)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.paddingSizeSmall,
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    ProductDetailsWidget(productModel: widget.productModel),
                    ProductReviewWidget(productModel: widget.productModel),
                  ],
                )),
              ]);
            },
          ),
        ));
  }
}
