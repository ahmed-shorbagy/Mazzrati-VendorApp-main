// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/data/model/image_full_url.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/helper/price_converter.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:provider/provider.dart';

import '../widgets/product_form/action_buttons.dart';
import '../widgets/product_form/price_stock_section.dart';
import '../widgets/product_form/product_image_section.dart';

class AddProductNextScreen extends StatefulWidget {
  final Product? product;
  final String? categoryId;
  final String? subCategoryId;
  final String? subSubCategoryId;
  final String? brandId;
  final AddProductModel? addProduct;
  final String? unit;
  final bool? isFromSuggestion;

  const AddProductNextScreen({
    super.key,
    this.product,
    this.categoryId,
    this.subCategoryId,
    this.subSubCategoryId,
    this.brandId,
    this.addProduct,
    this.unit,
    this.isFromSuggestion = false,
  });

  @override
  AddProductNextScreenState createState() => AddProductNextScreenState();
}

class AddProductNextScreenState extends State<AddProductNextScreen> {
  final FocusNode _discountNode = FocusNode();
  final FocusNode _shippingCostNode = FocusNode();
  final FocusNode _unitPriceNode = FocusNode();
  final FocusNode _totalQuantityNode = FocusNode();
  final FocusNode _minimumOrderQuantityNode = FocusNode();
  final GlobalKey<FormState> _shippingFormKey = GlobalKey<FormState>();
  final TextEditingController _shippingCapacityController =
      TextEditingController();
  final TextEditingController _minDeliveryLimitController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeProduct();
  }

  void _initializeProduct() {
    final provider = Provider.of<AddProductController>(context, listen: false);
    provider.taxController.text = '0';
    provider.discountController.text = '0';
    provider.shippingCostController.text = '0';
    provider.minimumOrderQuantityController.text = '1';

    if (widget.product != null) {
      _updateWithExistingProduct(provider);
    }
  }

  void _updateWithExistingProduct(AddProductController provider) {
    provider.unitPriceController.text =
        PriceConverter.convertPriceWithoutSymbol(
      context,
      widget.product!.unitPrice,
    );
    provider.taxController.text = widget.product!.tax.toString();
    provider.setCurrentStock(widget.product!.currentStock.toString());
    provider.shippingCostController.text =
        widget.product!.shippingCost.toString();
    provider.minimumOrderQuantityController.text =
        widget.product!.minimumOrderQty.toString();
    provider.setDiscountTypeIndex(
      widget.product!.discountType == 'percent' ? 0 : 1,
      false,
    );
    provider.discountController.text = widget.product!.discountType == 'percent'
        ? widget.product!.discount.toString()
        : PriceConverter.convertPriceWithoutSymbol(
            context,
            widget.product!.discount,
          );
    provider.setTaxTypeIndex(
        widget.product!.taxModel == 'include' ? 0 : 1, false);
  }

  @override
  void dispose() {
    _shippingCapacityController.dispose();
    _minDeliveryLimitController.dispose();
    super.dispose();
  }

  bool _validateForm(BuildContext context) {
    final provider = Provider.of<AddProductController>(context, listen: false);
    final unitPrice = provider.unitPriceController.text.trim();
    final currentStock = provider.totalQuantityController.text.trim();
    final orderQuantity = provider.minimumOrderQuantityController.text.trim();

    if (provider.pickedLogo == null) {
      showCustomSnackBarWidget(
        getTranslated('upload_thumbnail_image', context),
        context,
        isError: true,
      );
      return false;
    }

    if (unitPrice.isEmpty) {
      showCustomSnackBarWidget(
        getTranslated('enter_unit_price', context),
        context,
        isError: true,
      );
      return false;
    }

    if (currentStock.isEmpty && provider.productTypeIndex == 0) {
      showCustomSnackBarWidget(
        getTranslated('enter_total_quantity', context),
        context,
        isError: true,
      );
      return false;
    }

    if (orderQuantity.isEmpty) {
      showCustomSnackBarWidget(
        getTranslated('enter_minimum_order_quantity', context),
        context,
        isError: true,
      );
      return false;
    }

    if (provider.productTypeIndex == 0 &&
        provider.shippingCostController.text.isEmpty) {
      showCustomSnackBarWidget(
        getTranslated('enter_shipping_cost', context),
        context,
        isError: true,
      );
      return false;
    }

    if (!_shippingFormKey.currentState!.validate()) {
      return false;
    }

    return true;
  }

  void _navigateToSeoScreen() {
    if (_validateForm(context)) {
      final provider =
          Provider.of<AddProductController>(context, listen: false);
      final splashProvider =
          Provider.of<SplashController>(context, listen: false);

      // Get shipping values directly from controllers
      int? shippingCapacity =
          int.tryParse(_shippingCapacityController.text.trim());

      // Validate shipping values
      if (shippingCapacity == null) {
        showCustomSnackBarWidget(
          getTranslated('please_enter_shipping_info', context),
          context,
          isError: true,
        );
        return;
      }

      if (shippingCapacity <= 0) {
        showCustomSnackBarWidget(
          getTranslated('please_enter_valid_shipping_values', context),
          context,
          isError: true,
        );
        return;
      }

      // Create Product model with validated shipping values
      Product product = Product(
        tax: double.parse(provider.taxController.text.trim()),
        unitPrice: double.parse(provider.unitPriceController.text.trim()),
        discount: provider.discountController.text.isNotEmpty
            ? double.parse(provider.discountController.text.trim())
            : 0,
        discountType: provider.discountTypeIndex == 0 ? 'percent' : 'flat',
        taxModel: provider.taxTypeIndex == 0 ? 'include' : 'exclude',
        shippingType: provider.shippingType,
        thumbnail: '', // Will be set after image upload
        thumbnailFullUrl: null, // Will be set after image upload
        shippingCapacity: shippingCapacity,
        shippingCost: provider.shippingCostController.text.isNotEmpty
            ? double.parse(provider.shippingCostController.text.trim())
            : 0.0,
        minimumOrderQty:
            int.parse(provider.minimumOrderQuantityController.text.trim()),
        productType: provider.productTypeIndex == 0 ? 'physical' : 'digital',
        currentStock: provider.totalQuantityController.text.isNotEmpty
            ? int.parse(provider.totalQuantityController.text.trim())
            : 0,
        unit: widget.unit,
        categoryIds: [CategoryIds(id: widget.categoryId ?? '0')],
        brandId: widget.brandId != null ? int.parse(widget.brandId!) : 0,
      );

      // Create AddProductModel
      AddProductModel addProduct = AddProductModel(
        titleList: provider.titleControllerList.map((e) => e.text).toList(),
        descriptionList:
            provider.descriptionControllerList.map((e) => e.text).toList(),
        languageList: splashProvider.configModel?.languageList
            ?.map((e) => e.code)
            .toList(),
        colorCodeList: provider.colorCodeList,
        thumbnailList:
            provider.pickedLogo != null ? [provider.pickedLogo!.path] : [],
        videoUrl: '',
      );

      // First upload the thumbnail if it exists
      if (provider.pickedLogo != null) {
        provider.addProductImage(
          context,
          provider.thumbnail,
          (bool isSuccess, String name, String type, String? colorCode) {
            if (isSuccess && type == 'thumbnail') {
              // Now that we have the server-side thumbnail name, update the product
              product.thumbnail = name;
              product.thumbnailFullUrl = ImageFullUrl(
                path: provider.pickedLogo!.path,
                key: name,
                status: 200,
              );

              // Now call addProduct with the updated thumbnail
              provider.addProduct(
                context,
                product,
                addProduct,
                name, // Pass the server-returned thumbnail name
                null, // No meta image in this screen
                true,
                [],
              );
            }
          },
          update: widget.product != null,
        );
      } else if (widget.product != null) {
        // If updating and no new thumbnail, use existing
        provider.addProduct(
          context,
          product,
          addProduct,
          widget.product?.thumbnail,
          null,
          true,
          [],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool value) {
        Provider.of<AddProductController>(context, listen: false)
            .setSelectedPageIndex(0, isUpdate: true);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: widget.product != null
              ? getTranslated('update_product', context)
              : getTranslated('add_product', context),
          onBackPressed: () {
            Navigator.pop(context);
            Provider.of<AddProductController>(context, listen: false)
                .setSelectedPageIndex(0, isUpdate: true);
          },
        ),
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProductImageSection(),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      PriceStockSection(
                        shippingFormKey: _shippingFormKey,
                        shippingCapacityController: _shippingCapacityController,
                        minDeliveryLimitController: _minDeliveryLimitController,
                        discountNode: _discountNode,
                        shippingCostNode: _shippingCostNode,
                        unitPriceNode: _unitPriceNode,
                        totalQuantityNode: _totalQuantityNode,
                        minimumOrderQuantityNode: _minimumOrderQuantityNode,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],
                  ),
                ),
              ),
              ActionButtons(
                onBack: () {
                  Navigator.pop(context);
                  Provider.of<AddProductController>(context, listen: false)
                      .setSelectedPageIndex(0, isUpdate: true);
                },
                onNext: _navigateToSeoScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
