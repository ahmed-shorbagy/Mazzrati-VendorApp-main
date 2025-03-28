import 'dart:math';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/models/edt_product_model.dart';
import 'package:mazzraati_vendor_app/features/addProduct/screens/add_product_next_screen.dart';
import 'package:mazzraati_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/widgets/digital_product_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/widgets/select_category_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/widgets/title_and_description_widget.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/main.dart';
import 'package:mazzraati_vendor_app/theme/controllers/theme_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  final bool? isFromSuggestion;
  final AddProductModel? addProduct;
  final EditProductModel? editProduct;
  final bool? fromHome;
  const AddProductScreen(
      {super.key,
      this.product,
      this.addProduct,
      this.editProduct,
      this.fromHome = false,
      this.isFromSuggestion = false});
  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int? length;
  late bool _update;
  int cat = 0, subCat = 0, subSubCat = 0, unit = 0, brand = 0;
  String? unitValue = '';
  List<String> titleList = [];
  List<String> descriptionList = [];

  String? selectedUnitType;
  TextEditingController weightController = TextEditingController();
  TextEditingController volumeController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController pieceController = TextEditingController();
  TextEditingController cmController = TextEditingController();
  TextEditingController meterController = TextEditingController();
  TextEditingController literController = TextEditingController();

  Future<void> _load() async {
    Provider.of<AddProductController>(context, listen: false).resetCategory();
    String languageCode =
        Provider.of<LocalizationController>(context, listen: false)
                    .locale
                    .countryCode ==
                'US'
            ? 'en'
            : Provider.of<LocalizationController>(context, listen: false)
                .locale
                .countryCode!
                .toLowerCase();
    await Provider.of<SplashController>(Get.context!, listen: false)
        .getColorList();
    await Provider.of<AddProductController>(Get.context!, listen: false)
        .getAttributeList(Get.context!, widget.product, languageCode);
    await Provider.of<AddProductController>(Get.context!, listen: false)
        .getCategoryList(Get.context!, widget.product, languageCode);
    await Provider.of<AddProductController>(Get.context!, listen: false)
        .getBrandList(Get.context!, languageCode);
    if (!_update && widget.product?.brandId == null) {
      Provider.of<AddProductController>(Get.context!, listen: false)
          .setBrandIndex(0, false);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: Provider.of<SplashController>(context, listen: false)
            .configModel!
            .languageList!
            .length,
        initialIndex: 0,
        vsync: this);
    _tabController?.addListener(() {});

    Provider.of<AddProductController>(context, listen: false)
        .setSelectedPageIndex(0, isUpdate: false);
    _load();
    length = Provider.of<SplashController>(context, listen: false)
        .configModel!
        .languageList!
        .length;
    _update = widget.product != null;
    Provider.of<AddProductController>(context, listen: false).initColorCode();
    if (widget.product != null) {
      unitValue = widget.product!.unit;
      if (widget.isFromSuggestion == true) {
        Provider.of<AddProductController>(context, listen: false)
            .productCode
            .clear();
      } else {
        Provider.of<AddProductController>(context, listen: false)
            .productCode
            .text = widget.product!.code ?? '123456';
      }
      Provider.of<AddProductController>(context, listen: false)
          .getEditProduct(context, widget.product!.id);
      Provider.of<AddProductController>(context, listen: false)
          .setValueForUnit(widget.product!.unit.toString());
      Provider.of<AddProductController>(context, listen: false)
          .setProductTypeIndex(
              widget.product!.productType == "physical" ? 0 : 1, false);
      Provider.of<AddProductController>(context, listen: false)
          .setDigitalProductTypeIndex(
              widget.product!.digitalProductType == "ready_after_sell" ? 0 : 1,
              false);
    } else {
      Provider.of<AddProductController>(context, listen: false)
          .setCurrentStock('1');
      Provider.of<AddProductController>(context, listen: false)
          .getTitleAndDescriptionList(
              Provider.of<SplashController>(context, listen: false)
                  .configModel!
                  .languageList!,
              null);
      Provider.of<AddProductController>(context, listen: false)
          .emptyDigitalProductData();
    }
  }

  Widget _buildUnitSelection(AddProductController resProvider) {
    bool isArabic = Provider.of<LocalizationController>(context, listen: false)
            .locale
            .countryCode !=
        'US';

    // Reset selectedUnitType if it's not in the current category's units
    if (selectedUnitType != null &&
        !resProvider.categoryUnits!.contains(selectedUnitType)) {
      selectedUnitType = null;
    }

    // Convert طول (length) to متر (meter) when selected
    if (selectedUnitType == 'طول' || selectedUnitType == 'length') {
      selectedUnitType = isArabic ? 'متر' : 'meter';
      resProvider.setValueForUnit(selectedUnitType);
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated('units', context)!,
            style: robotoRegular.copyWith(
              color: ColorResources.titleColor(context),
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          if (resProvider.categoryUnits != null)
            DropdownButton<String>(
              value: selectedUnitType,
              items: resProvider.categoryUnits!.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  // Convert طول to متر when selected
                  if (value == 'طول' || value == 'length') {
                    selectedUnitType = isArabic ? 'متر' : 'meter';
                  } else {
                    selectedUnitType = value;
                  }

                  // Clear previous controller values when unit changes
                  weightController.clear();
                  volumeController.clear();
                  lengthController.clear();
                  pieceController.clear();

                  // Set the unitValue in the provider when unit is selected
                  resProvider.setValueForUnit(selectedUnitType);

                  // Reset unit quantity
                  resProvider.unitQuantityController.clear();
                  resProvider.setUnitQuantity('');
                });
              },
              hint: Text(getTranslated('select_unit', context)!),
              isExpanded: true,
              underline: Container(
                height: 1,
                color: Theme.of(context).primaryColor,
              ),
            ),
          if (selectedUnitType != null)
            Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: TextFormField(
                controller: _getControllerForUnit(selectedUnitType!),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'أدخل ${_getLabelForUnit(selectedUnitType!)}',
                  suffixText: selectedUnitType,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                    borderSide: BorderSide(
                      width: .5,
                      color: Theme.of(context).primaryColor.withOpacity(.7),
                    ),
                  ),
                ),
                onChanged: (value) {
                  // When value changes, update unitQuantityController in provider
                  if (value.isNotEmpty) {
                    double? qty = double.tryParse(value);
                    if (qty != null) {
                      resProvider.setUnitQuantity(value);
                      // Also update the controller in the provider
                      resProvider.unitQuantityController.text = value;
                    }
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  TextEditingController _getControllerForUnit(String unit) {
    switch (unit) {
      case 'كيلو':
      case 'kg':
        return weightController;
      case 'لتر':
      case 'liter':
        return literController;
      case 'متر':
      case 'meter':
        return meterController;
      case 'سم':
      case 'cm':
        return cmController;
      case 'قطعة':
      case 'piece':
        return pieceController;
      case 'طول':
      case 'length':
        return meterController; // Use meter controller for length
      default:
        return TextEditingController();
    }
  }

  String _getLabelForUnit(String unit) {
    bool isArabic = Provider.of<LocalizationController>(context, listen: false)
            .locale
            .countryCode !=
        'US';

    switch (unit) {
      case 'كيلو':
      case 'kg':
        return isArabic ? 'الوزن' : 'Weight';
      case 'لتر':
      case 'liter':
        return isArabic ? 'الحجم' : 'Volume';
      case 'متر':
      case 'meter':
      case 'طول':
      case 'length':
        return isArabic ? 'الطول' : 'Length';
      case 'سم':
      case 'cm':
        return isArabic ? 'الطول' : 'Length';
      case 'قطعة':
      case 'piece':
        return isArabic ? 'القطع' : 'Pieces';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    late List<int?> brandIds;
    return PopScope(
      canPop: true,
      onPopInvoked: (value) {
        Provider.of<AddProductController>(context, listen: false)
            .removeCategory();
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
            title: (widget.product != null && widget.isFromSuggestion == false)
                ? getTranslated('update_product', context)
                : getTranslated('add_product', context)),
        body: Consumer<AddProductController>(
          builder: (context, resProvider, child) {
            brandIds = [];
            brandIds.add(0);
            if (resProvider.brandList != null) {
              for (int index = 0;
                  index < resProvider.brandList!.length;
                  index++) {
                brandIds.add(resProvider.brandList![index].id);
              }
              if (_update && widget.product!.brandId != null) {
                if (brand == 0) {
                  resProvider.setBrandIndex(
                      brandIds.indexOf(widget.product!.brandId), false);
                  brand++;
                }
              }
            }
            return widget.product != null && resProvider.editProduct == null
                ? const Center(child: CircularProgressIndicator())
                : length != null
                    ? Consumer<SplashController>(
                        builder: (context, splashController, _) {
                        return Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AddProductSectionWidget(
                                        title: '',
                                        childrens: [
                                          SizedBox(
                                            height: 240,
                                            child: _generateTabPage(
                                                resProvider)[0],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                      AddProductSectionWidget(
                                        title: getTranslated(
                                            'general_setup', context)!,
                                        childrens: [
                                          const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall),
                                          if (widget.isFromSuggestion ==
                                              false) ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeDefault),
                                              child: SelectCategoryWidget(
                                                product: widget.product,
                                                onCategoryChanged: () {
                                                  // Reset selectedUnitType when category changes
                                                  setState(() {
                                                    selectedUnitType = null;
                                                  });
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeDefault,
                                                vertical:
                                                    Dimensions.paddingSizeSmall,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated(
                                                        'is_organic', context)!,
                                                    style:
                                                        robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault,
                                                      color: ColorResources
                                                          .titleColor(context),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: false,
                                                        groupValue: resProvider
                                                            .isOrganic,
                                                        onChanged:
                                                            (bool? value) {
                                                          resProvider
                                                              .setIsOrganic(
                                                                  value ??
                                                                      false);
                                                        },
                                                        activeColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                      ),
                                                      Text(
                                                        getTranslated(
                                                            'no', context)!,
                                                        style: robotoRegular,
                                                      ),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeDefault),
                                                      Radio(
                                                        value: true,
                                                        groupValue: resProvider
                                                            .isOrganic,
                                                        onChanged:
                                                            (bool? value) {
                                                          resProvider
                                                              .setIsOrganic(
                                                                  value ??
                                                                      true);
                                                        },
                                                        activeColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                      ),
                                                      Text(
                                                        getTranslated(
                                                            'yes', context)!,
                                                        style: robotoRegular,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Provider.of<SplashController>(
                                                            context,
                                                            listen: false)
                                                        .configModel!
                                                        .brandSetting ==
                                                    "1"
                                                ? const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeDefault),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [],
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            const SizedBox(
                                                height: Dimensions
                                                    .paddingSizeSmall),
                                          ],
                                          if (resProvider.productTypeIndex ==
                                                  0 &&
                                              resProvider.categoryIndex != 0)
                                            _buildUnitSelection(resProvider),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraSmall),
                                          Provider.of<SplashController>(context,
                                                          listen: false)
                                                      .configModel!
                                                      .digitalProductSetting ==
                                                  "1"
                                              ? DigitalProductWidget(
                                                  resProvider: resProvider,
                                                  product: widget.product)
                                              : const SizedBox(),
                                          const SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraSmall),
                                          const SizedBox(height: 15)
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeDefault),
                              height: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[
                                          Provider.of<ThemeController>(context)
                                                  .darkTheme
                                              ? 800
                                              : 200]!,
                                      spreadRadius: 0.5,
                                      blurRadius: 0.3)
                                ],
                              ),
                              child: Consumer<AddProductController>(
                                  builder: (context, resProvider, _) {
                                return !resProvider.isLoading
                                    ? SizedBox(
                                        height: 50,
                                        child: InkWell(
                                          onTap: resProvider.categoryList ==
                                                  null
                                              ? null
                                              : () {
                                                  bool haveBlankTitle = true;
                                                  bool haveBlankDes = false;

                                                  for (TextEditingController title
                                                      in resProvider
                                                          .titleControllerList) {
                                                    if (title.text.isNotEmpty) {
                                                      haveBlankTitle = false;
                                                      break;
                                                    }
                                                  }

                                                  String generateSKU() {
                                                    const chars =
                                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
                                                    final random = Random();
                                                    String sku = '';

                                                    for (int i = 0;
                                                        i < 6;
                                                        i++) {
                                                      sku += chars[
                                                          random.nextInt(
                                                              chars.length)];
                                                    }
                                                    return sku;
                                                  }

                                                  if (widget.product == null ||
                                                      widget.isFromSuggestion ==
                                                          true) {
                                                    String code = generateSKU();
                                                    resProvider.productCode
                                                        .text = code.toString();
                                                  }

                                                  if (haveBlankTitle) {
                                                    showCustomSnackBarWidget(
                                                        getTranslated(
                                                            'please_input_all_title',
                                                            context),
                                                        context,
                                                        sanckBarType:
                                                            SnackBarType
                                                                .warning);
                                                  } else if (resProvider
                                                          .categoryIndex ==
                                                      0) {
                                                    showCustomSnackBarWidget(
                                                      getTranslated(
                                                          'select_a_category',
                                                          context),
                                                      context,
                                                      sanckBarType:
                                                          SnackBarType.warning,
                                                    );
                                                  } else if (resProvider
                                                              .unitValue ==
                                                          '' ||
                                                      resProvider.unitValue ==
                                                              null &&
                                                          resProvider
                                                                  .productTypeIndex ==
                                                              0) {
                                                    showCustomSnackBarWidget(
                                                        getTranslated(
                                                            'select_a_unit',
                                                            context),
                                                        context,
                                                        sanckBarType:
                                                            SnackBarType
                                                                .warning);
                                                  } else if (resProvider
                                                              .productCode
                                                              .text
                                                              .length <
                                                          6 ||
                                                      resProvider.productCode
                                                              .text ==
                                                          '000000') {
                                                    showCustomSnackBarWidget(
                                                        getTranslated(
                                                            'product_code_minimum_6_digit',
                                                            context),
                                                        context,
                                                        sanckBarType:
                                                            SnackBarType
                                                                .warning);
                                                  } else {
                                                    for (TextEditingController textEditingController
                                                        in resProvider
                                                            .titleControllerList) {
                                                      titleList.add(
                                                          textEditingController
                                                              .text
                                                              .trim());
                                                    }
                                                    resProvider
                                                        .setSelectedPageIndex(1,
                                                            isUpdate: true);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => AddProductNextScreen(
                                                                categoryId: resProvider.categoryList![resProvider.categoryIndex! - 1].id
                                                                    .toString(),
                                                                subCategoryId: resProvider.subCategoryIndex != 0
                                                                    ? resProvider.subCategoryList![resProvider.subCategoryIndex! - 1].id
                                                                        .toString()
                                                                    : "-1",
                                                                subSubCategoryId:
                                                                    resProvider.subSubCategoryIndex != 0
                                                                        ? resProvider.subSubCategoryList![resProvider.subSubCategoryIndex! - 1].id
                                                                            .toString()
                                                                        : "-1",
                                                                brandId: brandIds[resProvider.brandIndex!]
                                                                    .toString(),
                                                                unit: unitValue,
                                                                product: widget
                                                                    .product,
                                                                addProduct: widget
                                                                    .addProduct,
                                                                isFromSuggestion:
                                                                    widget.isFromSuggestion)));
                                                  }
                                                },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: resProvider.categoryList ==
                                                      null
                                                  ? Theme.of(context).hintColor
                                                  : Theme.of(context)
                                                      .primaryColor,
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .paddingSizeExtraSmall),
                                            ),
                                            child: Center(
                                                child: Text(
                                              getTranslated('next', context)!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      Dimensions.fontSizeLarge),
                                            )),
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              }),
                            )
                          ],
                        );
                      })
                    : const SizedBox();
          },
        ),
      ),
    );
  }

  List<Widget> _generateTabChildren() {
    List<Widget> tabs = [];
    tabs.add(Text(
        Provider.of<SplashController>(context, listen: false)
            .configModel!
            .languageList![1]
            .name!
            .capitalize(),
        style: robotoBold.copyWith()));
    return tabs.reversed.toList();
  }

  List<Widget> _generateTabPage(AddProductController resProvider) {
    List<Widget> tabView = [];
    tabView.add(TitleAndDescriptionWidget(resProvider: resProvider, index: 1));
    return tabView.reversed.toList();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String parseHtmlString(String htmlString) {
  var document = html_parser.parse(htmlString);
  return document.body?.text ?? '';
}
