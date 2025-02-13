import 'dart:developer';
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/models/add_product_model.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/helper/price_converter.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:mazzraati_vendor_app/main.dart';
import 'package:mazzraati_vendor_app/theme/controllers/theme_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';

class AddProductSeoScreen extends StatefulWidget {
  final ValueChanged<bool>? isSelected;
  final Product? product;
  final String? unitPrice;
  final String? discount;
  final String? currentStock;
  final String? minimumOrderQuantity;
  final String? tax;
  final String? shippingCost;
  final String? categoryId;
  final String? subCategoryId;
  final String? subSubCategoryId;
  final String? brandyId;
  final String? unit;
  final bool? isFromSuggestion;

  final AddProductModel? addProduct;
  const AddProductSeoScreen(
      {super.key,
      this.isSelected,
      required this.product,
      required this.addProduct,
      required this.isFromSuggestion,
      this.unitPrice,
      this.tax,
      this.discount,
      this.currentStock,
      this.shippingCost,
      this.categoryId,
      this.subCategoryId,
      this.subSubCategoryId,
      this.brandyId,
      this.unit,
      this.minimumOrderQuantity});

  @override
  AddProductSeoScreenState createState() => AddProductSeoScreenState();
}

class AddProductSeoScreenState extends State<AddProductSeoScreen> {
  bool isSelected = false;
  final FocusNode _seoTitleNode = FocusNode();
  final FocusNode _seoDescriptionNode = FocusNode();
  final FocusNode _youtubeLinkNode = FocusNode();
  final TextEditingController _seoTitleController = TextEditingController();
  final TextEditingController _seoDescriptionController =
      TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();
  AutoCompleteTextField? searchTextField;
  late double _distanceToField;
  TextEditingController? _controller;
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  SimpleAutoCompleteTextField? textField;
  bool showWhichErrorText = false;
  late bool _update;
  Product? _product;
  AddProductModel? _addProduct;
  String? thumbnailImage = '', metaImage = '';
  int counter = 0, total = 0;
  int addColor = 0;
  List<String> tagList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  void initState() {
    _product = widget.product;

    _update = widget.product != null;
    _addProduct = widget.addProduct;
    if (_update) {
      if (_product!.tags != null) {
        for (int i = 0; i < _product!.tags!.length; i++) {
          tagList.add(_product!.tags![i].tag!);
        }
      }
      _seoTitleController.text = _product!.metaSeoInfo != null
          ? _product!.metaSeoInfo?.metaTitle ?? ''
          : _product!.metaTitle ?? '';
      _seoDescriptionController.text = _product!.metaSeoInfo != null
          ? _product!.metaSeoInfo?.metaDescription ?? ''
          : _product!.metaDescription ?? '';
      log(widget.product!.toJson().toString());
      log(_product!.toJson().toString());

      log("Thumbnail_full_url${_product!.thumbnailFullUrl}");

      thumbnailImage = _product!.thumbnail;
      metaImage = _product!.metaImage;

      if (_product?.imagesFullUrl != null) {
        List<Map<String, dynamic>>? productImages = [];
        for (int i = 0; i < _product!.imagesFullUrl!.length; i++) {
          productImages.add({
            "image_name": _product?.imagesFullUrl?[i].key ?? '',
            "storage": null,
          });
        }
        // Provider.of<AddProductController>(context,listen: false).productReturnImage = productImages;
      }
    } else {
      _product = Product();
      _addProduct = AddProductModel();
    }
    _controller = TextEditingController();
    super.initState();
  }

  route(bool isRoute, String name, String type, String? colorCode) async {
    print("<<=====RouteCall=====>>");

    if (isRoute) {
      if (type == 'meta') {
        metaImage = name;
      } else if (type == 'thumbnail') {
        thumbnailImage = name;
      }
      if (_update) {
        int withc = 0, withOurC = 0;
        if (Provider.of<AddProductController>(Get.context!, listen: false)
            .withColor
            .isNotEmpty) {
          for (int index = 0;
              index <
                  Provider.of<AddProductController>(Get.context!, listen: false)
                      .withColor
                      .length;
              index++) {
            String retColor =
                Provider.of<AddProductController>(Get.context!, listen: false)
                    .withColor[index]
                    .color!;
            String? bb;
            if (retColor.contains('#')) {
              bb = retColor.replaceAll('#', '');
            }
            if (bb == colorCode) {
              Provider.of<AddProductController>(Get.context!, listen: false)
                  .setStringImage(index, name, colorCode!);
              break;
            }
          }
        }

        for (int i = 0;
            i <
                Provider.of<AddProductController>(Get.context!, listen: false)
                    .withColor
                    .length;
            i++) {
          if (Provider.of<AddProductController>(Get.context!, listen: false)
                  .withColor[i]
                  .image !=
              null) {
            withc++;
          }
        }

        for (int i = 0;
            i <
                Provider.of<AddProductController>(Get.context!, listen: false)
                    .withoutColor
                    .length;
            i++) {
          if (Provider.of<AddProductController>(Get.context!, listen: false)
                  .withoutColor[i]
                  .image !=
              null) {
            withOurC++;
          }
        }

        log("--===> Image is ==> ${Provider.of<AddProductController>(Get.context!, listen: false).totalPickedImage} and ${Provider.of<AddProductController>(Get.context!, listen: false).totalUploaded}");
        if (Provider.of<AddProductController>(Get.context!, listen: false)
                .totalUploaded >=
            (withc + withOurC)) {
          Provider.of<AddProductController>(Get.context!, listen: false)
              .addProduct(
                  context,
                  _product!,
                  _addProduct!,
                  thumbnailImage,
                  metaImage,
                  (!_update || widget.isFromSuggestion == true),
                  tagList);
        }
      } else {
        if (Provider.of<AddProductController>(Get.context!, listen: false)
            .withColor
            .isNotEmpty) {
          for (int index = 0;
              index <
                  Provider.of<AddProductController>(Get.context!, listen: false)
                      .withColor
                      .length;
              index++) {
            String retColor =
                Provider.of<AddProductController>(Get.context!, listen: false)
                    .withColor[index]
                    .color!;
            String? bb;
            if (retColor.contains('#')) {
              bb = retColor.replaceAll('#', '');
            }
            if (bb == colorCode) {
              Provider.of<AddProductController>(Get.context!, listen: false)
                  .setStringImage(index, name, colorCode!);
              break;
            }
          }
        }
        if (Provider.of<AddProductController>(Get.context!, listen: false)
            .withoutColor
            .isNotEmpty) {
          for (int index = 0;
              index <
                  Provider.of<AddProductController>(Get.context!, listen: false)
                      .withoutColor
                      .length;
              index++) {}
        }

        counter++;

        if (metaImage == '') {
          total = Provider.of<AddProductController>(Get.context!, listen: false)
                  .withColor
                  .length +
              Provider.of<AddProductController>(Get.context!, listen: false)
                  .withoutColor
                  .length +
              1;
        } else {
          total = Provider.of<AddProductController>(Get.context!, listen: false)
                  .withColor
                  .length +
              Provider.of<AddProductController>(Get.context!, listen: false)
                  .withoutColor
                  .length +
              2;
        }

        if (counter == total) {
          counter++;
          Provider.of<AddProductController>(Get.context!, listen: false)
              .addProduct(
                  context,
                  _product!,
                  _addProduct!,
                  thumbnailImage,
                  metaImage,
                  (!_update || widget.isFromSuggestion == true),
                  tagList);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool value) {
        Provider.of<AddProductController>(context, listen: false)
            .setSelectedPageIndex(1, isUpdate: true);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          title: (widget.product != null && widget.isFromSuggestion != true)
              ? getTranslated('update_product', context)
              : getTranslated('add_product', context),
          onBackPressed: () {
            Navigator.pop(context);
            Provider.of<AddProductController>(context, listen: false)
                .setSelectedPageIndex(1, isUpdate: true);
          },
        ),
        body: SafeArea(
          child: Consumer<AddProductController>(
            builder: (context, resProvider, child) {
              return Column(
                children: [
                  // Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: Dimensions.paddingSizeDefault),
                  //     child: AddProductTitleBar()),
                  Expanded(
                    child: SingleChildScrollView(
                      child: (resProvider.attributeList != null &&
                              resProvider.attributeList!.isNotEmpty &&
                              resProvider.categoryList != null &&
                              Provider.of<SplashController>(context,
                                          listen: false)
                                      .colorList !=
                                  null)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                        height: Dimensions.paddingSizeSmall),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeSmall),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeSmall),
                                    // Text(getTranslated('meta_image', context)!,
                                    //     style: robotoRegular.copyWith(
                                    //         fontSize:
                                    //             Dimensions.fontSizeDefault,
                                    //         color: ColorResources.titleColor(
                                    //             context))),
                                    // const SizedBox(
                                    //     height:
                                    //         Dimensions.paddingSizeExtraSmall),
                                    // Align(
                                    //     alignment: Alignment.center,
                                    //     child: Stack(children: [
                                    //       ClipRRect(
                                    //         borderRadius: BorderRadius.circular(
                                    //             Dimensions.paddingSizeSmall),
                                    //         child: resProvider.pickedMeta !=
                                    //                 null
                                    //             ? Image.file(
                                    //                 File(resProvider
                                    //                     .pickedMeta!.path),
                                    //                 width: 150,
                                    //                 height: 120,
                                    //                 fit: BoxFit.cover,
                                    //               )
                                    //             : widget.product != null
                                    //                 ? FadeInImage.assetNetwork(
                                    //                     placeholder: Images
                                    //                         .placeholderImage,
                                    //                     image: _product!
                                    //                                 .metaSeoInfo !=
                                    //                             null
                                    //                         ? _product!
                                    //                                 .metaSeoInfo
                                    //                                 ?.imageFullUrl
                                    //                                 ?.path ??
                                    //                             ''
                                    //                         : _product!
                                    //                                 .metaImageFullUrl
                                    //                                 ?.path ??
                                    //                             '',
                                    //                     height: 120,
                                    //                     width: 150,
                                    //                     fit: BoxFit.cover,
                                    //                     imageErrorBuilder: (c,
                                    //                             o, s) =>
                                    //                         Image.asset(
                                    //                             Images
                                    //                                 .placeholderImage,
                                    //                             height: 120,
                                    //                             width: 150,
                                    //                             fit: BoxFit
                                    //                                 .cover),
                                    //                   )
                                    //                 : Image.asset(
                                    //                     Images.placeholderImage,
                                    //                     height: 120,
                                    //                     width: 150,
                                    //                     fit: BoxFit.cover),
                                    //       ),
                                    //       Positioned(
                                    //         bottom: 0,
                                    //         right: 0,
                                    //         top: 0,
                                    //         left: 0,
                                    //         child: InkWell(
                                    //           splashColor: Colors.transparent,
                                    //           onTap: () =>
                                    //               resProvider.pickImage(
                                    //                   false, true, false, null),
                                    //           child: Container(
                                    //             decoration: BoxDecoration(
                                    //               color: Colors.black
                                    //                   .withOpacity(0.3),
                                    //               borderRadius: BorderRadius
                                    //                   .circular(Dimensions
                                    //                       .paddingSizeSmall),
                                    //               border: Border.all(
                                    //                   width: 1,
                                    //                   color: Theme.of(context)
                                    //                       .primaryColor),
                                    //             ),
                                    //             child: Container(
                                    //               margin:
                                    //                   const EdgeInsets.all(25),
                                    //               decoration: BoxDecoration(
                                    //                 border: Border.all(
                                    //                     width: 2,
                                    //                     color: Colors.white),
                                    //                 shape: BoxShape.circle,
                                    //               ),
                                    //               child: const Icon(
                                    //                   Icons.camera_alt,
                                    //                   color: Colors.white),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ])),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    Text(getTranslated('thumbnail', context)!,
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: ColorResources.titleColor(
                                                context))),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Stack(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.paddingSizeSmall),
                                            child: resProvider.pickedLogo !=
                                                    null
                                                ? Image.file(
                                                    File(resProvider
                                                        .pickedLogo!.path),
                                                    width: 150,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  )
                                                : widget.product != null
                                                    ? FadeInImage.assetNetwork(
                                                        placeholder: Images
                                                            .placeholderImage,
                                                        image: _product!
                                                                .thumbnailFullUrl
                                                                ?.path ??
                                                            '',
                                                        height: 120,
                                                        width: 150,
                                                        fit: BoxFit.cover,
                                                        imageErrorBuilder: (c,
                                                                o, s) =>
                                                            Image.asset(
                                                                Images
                                                                    .placeholderImage,
                                                                height: 120,
                                                                width: 150,
                                                                fit: BoxFit
                                                                    .cover),
                                                      )
                                                    : Image.asset(
                                                        Images.placeholderImage,
                                                        height: 120,
                                                        width: 150,
                                                        fit: BoxFit.cover,
                                                      ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            top: 0,
                                            left: 0,
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              onTap: () =>
                                                  resProvider.pickImage(
                                                      true, false, false, null,
                                                      isAddProduct:
                                                          widget.product ==
                                                              null),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  borderRadius: BorderRadius
                                                      .circular(Dimensions
                                                          .paddingSizeSmall),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.white),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ])),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    if (!_update)
                                      Text(
                                          getTranslated(
                                              'product_image', context)!,
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              color: ColorResources.titleColor(
                                                  context))),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    if (resProvider.attributeList![0].active &&
                                        resProvider.attributeList![0].variants
                                            .isNotEmpty)
                                      GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 1,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                          ),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              resProvider.withColor.length,
                                          itemBuilder: (context, index) {
                                            String colorString = '0xff000000';
                                            if (resProvider
                                                    .withColor[index].color !=
                                                null) {
                                              if (resProvider
                                                      .withColor[index].color !=
                                                  null) {
                                                colorString =
                                                    '0xff${resProvider.withColor[index].color!.substring(1, 7)}';
                                              }
                                            }

                                            print(
                                                "===ImageURl===>>${resProvider.withColor[index].colorImage?.imageName?.toJson() ?? ''}");
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: Dimensions
                                                      .paddingSizeSmall),
                                              child:
                                                  (resProvider.withColor[index]
                                                                  .color !=
                                                              null &&
                                                          resProvider
                                                                  .withColor[
                                                                      index]
                                                                  .image ==
                                                              null)
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            resProvider
                                                                .pickImage(
                                                                    false,
                                                                    false,
                                                                    false,
                                                                    index,
                                                                    update:
                                                                        _update);
                                                            log("=update=>$_update");
                                                            resProvider
                                                                .removeImage(
                                                                    index,
                                                                    true);
                                                            if (_update &&
                                                                resProvider
                                                                        .withColor[
                                                                            index]
                                                                        .imageString !=
                                                                    null &&
                                                                resProvider
                                                                    .withColor[
                                                                        index]
                                                                    .imageString!
                                                                    .isNotEmpty) {
                                                              resProvider.deleteProductImage(
                                                                  _product!.id
                                                                      .toString(),
                                                                  resProvider
                                                                      .withColor[
                                                                          index]
                                                                      .imageString
                                                                      .toString(),
                                                                  resProvider
                                                                      .withColor[
                                                                          index]
                                                                      .color
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "#",
                                                                          ""));
                                                            }
                                                          },
                                                          child: Stack(
                                                            children: [
                                                              DottedBorder(
                                                                  dashPattern: const [
                                                                    4,
                                                                    5
                                                                  ],
                                                                  borderType:
                                                                      BorderType
                                                                          .RRect,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                  radius: const Radius
                                                                      .circular(
                                                                      15),
                                                                  child: ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(Dimensions
                                                                              .paddingSizeSmall),
                                                                      child: (_update)
                                                                          ? CustomImageWidget(
                                                                              image: resProvider.withColor[index].colorImage?.imageName?.path ?? "",
                                                                              width: MediaQuery.of(context).size.width / 2.3,
                                                                              height: MediaQuery.of(context).size.width / 2.3,
                                                                              fit: BoxFit.cover)
                                                                          : Image.asset(Images.placeholderImage, height: MediaQuery.of(context).size.width / 2.3, width: MediaQuery.of(context).size.width / 2.3, fit: BoxFit.cover))),
                                                              Positioned(
                                                                  bottom: 0,
                                                                  right: 0,
                                                                  top: 0,
                                                                  left: 0,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Icon(
                                                                          Icons
                                                                              .camera_alt,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(.5),
                                                                          size: 40))),
                                                              Positioned(
                                                                  right: 5,
                                                                  top: 5,
                                                                  child: Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          color: Color(int.parse(
                                                                              colorString)),
                                                                          borderRadius: BorderRadius.circular(
                                                                              20)),
                                                                      child: Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Image.asset(Images.edit))))
                                                            ],
                                                          ),
                                                        )
                                                      : Stack(
                                                          children: [
                                                            DottedBorder(
                                                                dashPattern: const [
                                                                  4,
                                                                  5
                                                                ],
                                                                borderType:
                                                                    BorderType
                                                                        .RRect,
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor,
                                                                radius:
                                                                    const Radius
                                                                        .circular(
                                                                        15),
                                                                child:
                                                                    Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(20)),
                                                                        ),
                                                                        child: ClipRRect(
                                                                            borderRadius:
                                                                                const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                                                                            child: Image.file(File(resProvider.withColor[index].image!.path), width: MediaQuery.of(context).size.width / 2.3, height: MediaQuery.of(context).size.width / 2.3, fit: BoxFit.cover)))),
                                                            Positioned(
                                                                top: 5,
                                                                right: 5,
                                                                child: InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap: () {
                                                                      resProvider.pickImage(
                                                                          false,
                                                                          false,
                                                                          false,
                                                                          index);
                                                                      log("=update=>$_update");
                                                                      resProvider.removeImage(
                                                                          index,
                                                                          true);
                                                                      if (_update &&
                                                                          resProvider.withColor[index].imageString !=
                                                                              null &&
                                                                          resProvider
                                                                              .withColor[index]
                                                                              .imageString!
                                                                              .isNotEmpty) {
                                                                        resProvider.deleteProductImage(
                                                                            _product!.id
                                                                                .toString(),
                                                                            resProvider.withColorKeys[index]
                                                                                .toString(),
                                                                            resProvider.withColor[index].color.toString().replaceAll("#",
                                                                                ''));
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            30,
                                                                        decoration: BoxDecoration(
                                                                            color: Color(int.parse(
                                                                                colorString)),
                                                                            borderRadius: BorderRadius.circular(
                                                                                20)),
                                                                        child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child: Image.asset(Images.edit))))),
                                                          ],
                                                        ),
                                            );
                                          }),
                                    // if (_update)
                                    //   Consumer<AddProductController>(builder:
                                    //       (context, productProvider, _) {
                                    //     return GridView.builder(
                                    //         gridDelegate:
                                    //             const SliverGridDelegateWithFixedCrossAxisCount(
                                    //                 childAspectRatio: 1,
                                    //                 crossAxisCount: 2,
                                    //                 crossAxisSpacing: 10,
                                    //                 mainAxisSpacing: 10),
                                    //         shrinkWrap: true,
                                    //         physics:
                                    //             const NeverScrollableScrollPhysics(),
                                    //         itemCount: resProvider
                                    //             .imagesWithoutColor.length,
                                    //         itemBuilder:
                                    //             (BuildContext context, index) {
                                    //           return Stack(
                                    //             children: [
                                    //               DottedBorder(
                                    //                   dashPattern: const [4, 5],
                                    //                   borderType:
                                    //                       BorderType.RRect,
                                    //                   color: Theme.of(context)
                                    //                       .hintColor,
                                    //                   radius: const Radius.circular(
                                    //                       15),
                                    //                   child: Container(
                                    //                       decoration:
                                    //                           const BoxDecoration(
                                    //                         color: Colors.white,
                                    //                         borderRadius:
                                    //                             BorderRadius
                                    //                                 .all(Radius
                                    //                                     .circular(
                                    //                                         20)),
                                    //                       ),
                                    //                       child: ClipRRect(
                                    //                           borderRadius: const BorderRadius.all(
                                    //                               Radius.circular(
                                    //                                   Dimensions
                                    //                                       .paddingSizeSmall)),
                                    //                           child: CustomImageWidget(
                                    //                               image: resProvider.imagesWithoutColor[
                                    //                                   index],
                                    //                               width: MediaQuery.of(context)
                                    //                                       .size
                                    //                                       .width /
                                    //                                   2.3,
                                    //                               height: MediaQuery.of(context)
                                    //                                       .size
                                    //                                       .width /
                                    //                                   2.3,
                                    //                               fit: BoxFit.cover)))),
                                    //               Positioned(
                                    //                 top: 5,
                                    //                 right: 5,
                                    //                 child: InkWell(
                                    //                   splashColor:
                                    //                       Colors.transparent,
                                    //                   onTap: () {
                                    //                     resProvider
                                    //                         .deleteProductImage(
                                    //                             _product!.id
                                    //                                 .toString(),
                                    //                             resProvider
                                    //                                 .withoutColorKeys[
                                    //                                     index]
                                    //                                 .toString(),
                                    //                             null);
                                    //                   },
                                    //                   child: Container(
                                    //                       decoration:
                                    //                           BoxDecoration(
                                    //                               color: Colors
                                    //                                   .white,
                                    //                               boxShadow: [
                                    //                                 BoxShadow(
                                    //                                     color: Theme.of(context)
                                    //                                         .hintColor
                                    //                                         .withOpacity(
                                    //                                             .25),
                                    //                                     blurRadius:
                                    //                                         1,
                                    //                                     spreadRadius:
                                    //                                         1,
                                    //                                     offset: const Offset(
                                    //                                         0,
                                    //                                         0))
                                    //                               ],
                                    //                               borderRadius:
                                    //                                   const BorderRadius
                                    //                                       .all(
                                    //                                       Radius.circular(
                                    //                                           Dimensions.paddingSizeDefault))),
                                    //                       child: const Padding(
                                    //                         padding:
                                    //                             EdgeInsets.all(
                                    //                                 4.0),
                                    //                         child: Icon(
                                    //                           Icons
                                    //                               .delete_forever_rounded,
                                    //                           color: Colors.red,
                                    //                           size: 25,
                                    //                         ),
                                    //                       )),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           );
                                    //         });
                                    //   }),

                                    // (_update &&
                                    //         resProvider
                                    //             .imagesWithoutColor.isNotEmpty)
                                    //     ? const SizedBox(
                                    //         height: Dimensions.paddingSizeSmall)
                                    //     : const SizedBox(),
                                    if (!_update)
                                      GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 1,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                          ),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              resProvider.withoutColor.length +
                                                  1,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return index ==
                                                    resProvider
                                                        .withoutColor.length
                                                ? GestureDetector(
                                                    onTap: () =>
                                                        resProvider.pickImage(
                                                            false,
                                                            false,
                                                            false,
                                                            null),
                                                    child: Stack(
                                                      children: [
                                                        DottedBorder(
                                                          dashPattern: const [
                                                            4,
                                                            5
                                                          ],
                                                          borderType:
                                                              BorderType.RRect,
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                          radius: const Radius
                                                              .circular(15),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .paddingSizeSmall),
                                                            child: Image.asset(
                                                                Images
                                                                    .placeholderImage,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2.3,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2.3,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          top: 0,
                                                          left: 0,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                              size: 40,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Stack(
                                                    children: [
                                                      DottedBorder(
                                                        dashPattern: const [
                                                          4,
                                                          5
                                                        ],
                                                        borderType:
                                                            BorderType.RRect,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                        radius: const Radius
                                                            .circular(15),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    Dimensions
                                                                        .paddingSizeSmall)),
                                                            child: Image.file(
                                                              File(resProvider
                                                                  .withoutColor[
                                                                      index]
                                                                  .image!
                                                                  .path),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.3,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2.3,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        right: 5,
                                                        child: InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          onTap: () =>
                                                              resProvider
                                                                  .removeImage(
                                                                      index,
                                                                      false),
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Theme.of(context).hintColor.withOpacity(
                                                                                .25),
                                                                            blurRadius:
                                                                                1,
                                                                            spreadRadius:
                                                                                1,
                                                                            offset:
                                                                                const Offset(0, 0))
                                                                      ],
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(Dimensions
                                                                              .paddingSizeDefault))),
                                                              child:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            4.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .delete_forever_rounded,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 25,
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                          }),
                                    const SizedBox(height: 25),
                                  ]),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 300.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                    ),
                  ),
                  Consumer<AddProductController>(
                      builder: (context, resProvider, _) {
                    return Container(
                      height: 80,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
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
                      child: !resProvider.isLoading
                          ? Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.pop(context);
                                    resProvider.setSelectedPageIndex(1,
                                        isUpdate: true);
                                  },
                                  child: CustomButtonWidget(
                                    isColor: true,
                                    btnTxt: '${getTranslated('back', context)}',
                                    backgroundColor:
                                        Theme.of(context).hintColor,
                                  ),
                                )),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Expanded(
                                  child: CustomButtonWidget(
                                    btnTxt: (_update &&
                                            widget.isFromSuggestion == false)
                                        ? getTranslated('update', context)
                                        : getTranslated('submit', context),
                                    // onTap: () {
                                    //   resProvider.initUpload();
                                    //   String seoDescription =
                                    //       _seoDescriptionController.text.trim();
                                    //   String seoTitle =
                                    //       _seoTitleController.text.trim();
                                    //   String? unit = widget.unit;
                                    //   String? brandId = widget.brandyId;
                                    //   String metaTitle =
                                    //       _seoTitleController.text.trim();
                                    //   String metaDescription =
                                    //       _seoDescriptionController.text.trim();
                                    //   String videoUrl =
                                    //       _youtubeLinkController.text.trim();
                                    //   String multiPlyWithQuantity =
                                    //       resProvider.isMultiply ? '1' : '0';
                                    //   int multi =
                                    //       int.parse(multiPlyWithQuantity);
                                    //   String productCode =
                                    //       resProvider.productCode.text;
                                    //   bool isColorImageEmpty = false;

                                    //   List<String> titleList = [];
                                    //   List<String> descriptionList = [];
                                    //   for (TextEditingController textEditingController
                                    //       in resProvider.titleControllerList) {
                                    //     titleList.add(
                                    //         textEditingController.text.trim());
                                    //   }
                                    //   for (var description in resProvider
                                    //       .descriptionControllerList) {
                                    //     descriptionList
                                    //         .add(description.text.trim());
                                    //   }

                                    //   if (resProvider.withColor.isNotEmpty) {
                                    //     for (int i = 0;
                                    //         i < resProvider.withColor.length;
                                    //         i++) {
                                    //       if ((!_update ||
                                    //               widget.isFromSuggestion ==
                                    //                   true) &&
                                    //           resProvider.withColor[i].image ==
                                    //               null &&
                                    //           !isColorImageEmpty) {
                                    //         isColorImageEmpty = true;
                                    //       } else if (_update &&
                                    //           resProvider.withColor[i]
                                    //                   .colorImage?.imageName ==
                                    //               null &&
                                    //           !isColorImageEmpty) {
                                    //         isColorImageEmpty = true;
                                    //       }
                                    //     }
                                    //   }

                                    //   if ((!_update) &&
                                    //       resProvider.pickedLogo == null) {
                                    //     showCustomSnackBarWidget(
                                    //         getTranslated(
                                    //             'upload_thumbnail_image',
                                    //             context),
                                    //         context,
                                    //         sanckBarType: SnackBarType.warning);
                                    //   } else if ((!_update)
                                    //       //   ||
                                    //       //           widget.isFromSuggestion ==
                                    //       //               true)
                                    //       &&
                                    //       resProvider
                                    //           .attributeList![0].active &&
                                    //       resProvider.attributeList![0].variants
                                    //           .isNotEmpty &&
                                    //       isColorImageEmpty) {
                                    //     showCustomSnackBarWidget(
                                    //         getTranslated(
                                    //             'upload_product_color_image',
                                    //             context),
                                    //         context,
                                    //         sanckBarType: SnackBarType.warning);
                                    //   } else if ((!_update)
                                    //       //   ||
                                    //       //           widget.isFromSuggestion ==
                                    //       //               true)
                                    //       &&
                                    //       resProvider.withColor.length +
                                    //               resProvider
                                    //                   .withoutColor.length ==
                                    //           0) {
                                    //     showCustomSnackBarWidget(
                                    //         getTranslated(
                                    //             'upload_product_image',
                                    //             context),
                                    //         context,
                                    //         sanckBarType: SnackBarType.warning);
                                    //   } else {
                                    //     // log(PriceConverter
                                    //     //         .systemCurrencyToDefaultCurrency(
                                    //     //             double.parse(
                                    //     //                 widget.unitPrice!),
                                    //     //             context)
                                    //     //     .toString());
                                    //     _addProduct = AddProductModel();
                                    //     _addProduct!.titleList = titleList;
                                    //     _addProduct!.descriptionList =
                                    //         descriptionList;
                                    //     _addProduct!.videoUrl = videoUrl;
                                    //     _product!.tax =
                                    //         double.parse(widget.tax!);
                                    //     _product!.taxModel =
                                    //         resProvider.taxTypeIndex == 0
                                    //             ? 'include'
                                    //             : 'exclude';
                                    //     _product!.unitPrice = PriceConverter
                                    //         .systemCurrencyToDefaultCurrency(
                                    //             double.parse(widget.unitPrice!),
                                    //             context);
                                    //     _product!.discount = resProvider
                                    //                 .discountTypeIndex ==
                                    //             0
                                    //         ? double.parse(
                                    //             widget.discount ?? "0.0")
                                    //         : PriceConverter
                                    //             .systemCurrencyToDefaultCurrency(
                                    //                 double.parse(
                                    //                     widget.discount!),
                                    //                 context);
                                    //     _product!.productType =
                                    //         resProvider.productTypeIndex == 0
                                    //             ? 'physical'
                                    //             : 'digital';
                                    //     _product!.unit = unit;
                                    //     _product!.code = productCode;
                                    //     _product!.shippingCost = PriceConverter
                                    //         .systemCurrencyToDefaultCurrency(
                                    //             double.parse(
                                    //                 widget.shippingCost!),
                                    //             context);
                                    //     _product!.multiplyWithQuantity = multi;
                                    //     _product!.brandId = int.parse(brandId!);
                                    //     _product!.metaTitle = metaTitle;
                                    //     _product!.metaDescription =
                                    //         metaDescription;
                                    //     _product!.currentStock =
                                    //         int.parse(widget.currentStock!);
                                    //     _product!.minimumOrderQty = int.parse(
                                    //         widget.minimumOrderQuantity!);
                                    //     _product!.metaTitle = seoTitle;
                                    //     _product!.metaDescription =
                                    //         seoDescription;
                                    //     _product!.discountType =
                                    //         resProvider.discountType;
                                    //     _product!
                                    //         .digitalProductType = resProvider
                                    //                 .digitalProductTypeIndex ==
                                    //             0
                                    //         ? 'ready_after_sell'
                                    //         : 'ready_product';
                                    //     _product!.digitalFileReady =
                                    //         resProvider.digitalProductFileName;
                                    //     _product!.categoryIds = [];
                                    //     _product!.categoryIds!.add(
                                    //         CategoryIds(id: widget.categoryId));

                                    //     if (resProvider.subCategoryIndex != 0) {
                                    //       _product!.categoryIds!.add(
                                    //           CategoryIds(
                                    //               id: widget.subCategoryId));
                                    //     }

                                    //     if (resProvider.subSubCategoryIndex !=
                                    //         0) {
                                    //       _product!.categoryIds!.add(
                                    //           CategoryIds(
                                    //               id: widget.subSubCategoryId));
                                    //     }

                                    //     _addProduct!.colorCodeList = [];
                                    //     _addProduct!.colorCodeList!
                                    //         .addAll(resProvider.colorCodeList);

                                    //     _addProduct!.languageList = [];
                                    //     if (Provider.of<SplashController>(
                                    //                     context,
                                    //                     listen: false)
                                    //                 .configModel!
                                    //                 .languageList !=
                                    //             null &&
                                    //         Provider.of<SplashController>(
                                    //                 context,
                                    //                 listen: false)
                                    //             .configModel!
                                    //             .languageList!
                                    //             .isNotEmpty) {
                                    //       for (int i = 0;
                                    //           i <
                                    //               Provider.of<SplashController>(
                                    //                       context,
                                    //                       listen: false)
                                    //                   .configModel!
                                    //                   .languageList!
                                    //                   .length;
                                    //           i++) {
                                    //         _addProduct!.languageList!.insert(
                                    //             i,
                                    //             Provider.of<SplashController>(
                                    //                     context,
                                    //                     listen: false)
                                    //                 .configModel!
                                    //                 .languageList![i]
                                    //                 .code);
                                    //       }
                                    //     }

                                    //     if (_update) {
                                    //       int withc = 0, withOurC = 0;
                                    //       log("--===> Image is ==> ${resProvider.totalPickedImage} an ${resProvider.totalUploaded}");
                                    //       for (int i = 0;
                                    //           i < resProvider.withColor.length;
                                    //           i++) {
                                    //         if (resProvider
                                    //                 .withColor[i].image !=
                                    //             null) {
                                    //           withc++;
                                    //         }
                                    //       }

                                    //       for (int i = 0;
                                    //           i <
                                    //               resProvider
                                    //                   .withoutColor.length;
                                    //           i++) {
                                    //         if (resProvider
                                    //                 .withoutColor[i].image !=
                                    //             null) {
                                    //           withOurC++;
                                    //         }
                                    //       }
                                    //       if ((withc + withOurC) <=
                                    //               resProvider.totalUploaded &&
                                    //           resProvider.pickedLogo == null &&
                                    //           resProvider.pickedMeta == null) {
                                    //         resProvider.addProduct(
                                    //             context,
                                    //             _product!,
                                    //             _addProduct!,
                                    //             thumbnailImage,
                                    //             metaImage,
                                    //             (!_update ||
                                    //                 widget.isFromSuggestion ==
                                    //                     true),
                                    //             tagList);
                                    //       } else {
                                    //         if (resProvider.pickedLogo !=
                                    //             null) {
                                    //           resProvider.addProductImage(
                                    //               context,
                                    //               resProvider.thumbnail,
                                    //               route,
                                    //               update: _update);
                                    //         }

                                    //         if (resProvider.pickedMeta !=
                                    //             null) {
                                    //           resProvider.addProductImage(
                                    //               context,
                                    //               resProvider.metaImage,
                                    //               route,
                                    //               update: _update);
                                    //         }

                                    //         if (resProvider
                                    //             .withColor.isNotEmpty) {
                                    //           for (int i = 0;
                                    //               i <
                                    //                   resProvider
                                    //                       .withColor.length;
                                    //               i++) {
                                    //             if (resProvider
                                    //                     .withColor[i].image !=
                                    //                 null) {
                                    //               resProvider.addProductImage(
                                    //                   context,
                                    //                   resProvider.withColor[i],
                                    //                   route,
                                    //                   index: i,
                                    //                   update: _update);
                                    //             }
                                    //           }
                                    //         }

                                    //         if (resProvider
                                    //             .withoutColor.isNotEmpty) {
                                    //           log("--aikhane");
                                    //           for (int i = 0;
                                    //               i <
                                    //                   resProvider
                                    //                       .withoutColor.length;
                                    //               i++) {
                                    //             if (resProvider.withoutColor[i]
                                    //                     .image !=
                                    //                 null) {
                                    //               resProvider.addProductImage(
                                    //                   context,
                                    //                   resProvider
                                    //                       .withoutColor[i],
                                    //                   route,
                                    //                   index: i,
                                    //                   update: _update);
                                    //             }
                                    //           }
                                    //         }
                                    //       }
                                    //     } else {
                                    //       if (resProvider.pickedLogo != null) {
                                    //         resProvider.addProductImage(context,
                                    //             resProvider.thumbnail, route);
                                    //       }

                                    //       if (resProvider.pickedMeta != null) {
                                    //         resProvider.addProductImage(context,
                                    //             resProvider.metaImage, route);
                                    //       }

                                    //       if (resProvider
                                    //           .withColor.isNotEmpty) {
                                    //         for (int i = 0;
                                    //             i <
                                    //                 resProvider
                                    //                     .withColor.length;
                                    //             i++) {
                                    //           resProvider.addProductImage(
                                    //               context,
                                    //               resProvider.withColor[i],
                                    //               route);
                                    //         }
                                    //       }

                                    //       if (resProvider
                                    //           .withoutColor.isNotEmpty) {
                                    //         for (int i = 0;
                                    //             i <
                                    //                 resProvider
                                    //                     .withoutColor.length;
                                    //             i++) {
                                    //           resProvider.addProductImage(
                                    //               context,
                                    //               resProvider.withoutColor[i],
                                    //               route);
                                    //         }
                                    //       }
                                    //     }
                                    //   }
                                    // },
                                    onTap: () {
                                      resProvider.initUpload();
                                      // log("brand Id :${widget.brandyId}");

                                      // Extracting and trimming text inputs
                                      String seoDescription =
                                          _seoDescriptionController.text.trim();
                                      String seoTitle =
                                          _seoTitleController.text.trim();
                                      String? unit = widget.unit;
                                      // String? brandId = widget.brandyId;
                                      String? brandId = "1";
                                      String metaTitle = seoTitle;
                                      String metaDescription = seoDescription;
                                      String videoUrl =
                                          _youtubeLinkController.text.trim();
                                      String multiPlyWithQuantity =
                                          resProvider.isMultiply ? '1' : '0';
                                      int multi =
                                          int.tryParse(multiPlyWithQuantity) ??
                                              1;
                                      String productCode =
                                          resProvider.productCode.text;
                                      bool isColorImageEmpty = false;

                                      // Collecting title and description lists
                                      List<String> titleList = resProvider
                                          .titleControllerList
                                          .map((controller) =>
                                              controller.text.trim())
                                          .toList()
                                          .reversed
                                          .toList();

                                      List<String> descriptionList = resProvider
                                          .descriptionControllerList
                                          .map((controller) =>
                                              controller.text.trim())
                                          .toList()
                                          .reversed
                                          .toList();
                                      titleList = List.filled(
                                          titleList.length, titleList[0]);
                                      descriptionList = List.filled(
                                          descriptionList.length,
                                          descriptionList[0]);
                                      // Validating color image requirements
                                      if (resProvider.withColor.isNotEmpty) {
                                        for (var color
                                            in resProvider.withColor) {
                                          if ((!_update ||
                                                  widget.isFromSuggestion ==
                                                      true) &&
                                              color.image == null &&
                                              !isColorImageEmpty) {
                                            isColorImageEmpty = true;
                                          } else if (_update &&
                                              color.colorImage?.imageName ==
                                                  null &&
                                              !isColorImageEmpty) {
                                            isColorImageEmpty = true;
                                          }
                                        }
                                      }

                                      // Displaying warnings for missing images or attributes
                                      if (!_update &&
                                          resProvider.pickedLogo == null) {
                                        showCustomSnackBarWidget(
                                          getTranslated(
                                              'upload_thumbnail_image',
                                              context),
                                          context,
                                          sanckBarType: SnackBarType.warning,
                                        );
                                      } else if (!_update &&
                                          resProvider
                                              .attributeList![0].active &&
                                          resProvider.attributeList![0].variants
                                              .isNotEmpty &&
                                          isColorImageEmpty) {
                                        showCustomSnackBarWidget(
                                          getTranslated(
                                              'upload_product_color_image',
                                              context),
                                          context,
                                          sanckBarType: SnackBarType.warning,
                                        );
                                      } else if (!_update &&
                                          resProvider.withColor.isEmpty &&
                                          resProvider.withoutColor.isEmpty) {
                                        showCustomSnackBarWidget(
                                          getTranslated(
                                              'upload_product_image', context),
                                          context,
                                          sanckBarType: SnackBarType.warning,
                                        );
                                      } else {
                                        _addProduct = AddProductModel();
                                        _addProduct!.titleList = titleList;
                                        _addProduct!.descriptionList =
                                            descriptionList;
                                        _addProduct!.videoUrl = videoUrl;

                                        // Parsing and handling potential null values for numerical fields
                                        _product!.tax = widget.tax != null &&
                                                widget.tax!.isNotEmpty
                                            ? double.tryParse(widget.tax!) ??
                                                0.0
                                            : 0.0;
                                        _product!.taxModel =
                                            resProvider.taxTypeIndex == 0
                                                ? 'include'
                                                : 'exclude';
                                        _product!.unitPrice = widget
                                                        .unitPrice !=
                                                    null &&
                                                widget.unitPrice!.isNotEmpty
                                            ? PriceConverter
                                                .systemCurrencyToDefaultCurrency(
                                                double.tryParse(
                                                        widget.unitPrice!) ??
                                                    0.0,
                                                context,
                                              )
                                            : 0.0;
                                        _product!.discount = resProvider
                                                    .discountTypeIndex ==
                                                0
                                            ? (widget.discount != null &&
                                                    widget.discount!.isNotEmpty
                                                ? double.tryParse(
                                                        widget.discount!) ??
                                                    0.0
                                                : 0.0)
                                            : PriceConverter
                                                .systemCurrencyToDefaultCurrency(
                                                double.tryParse(
                                                        widget.discount!) ??
                                                    0.0,
                                                context,
                                              );
                                        _product!.productType =
                                            resProvider.productTypeIndex == 0
                                                ? 'physical'
                                                : 'digital';
                                        _product!.unit = unit;
                                        _product!.code = productCode;
                                        _product!.shippingCost = widget
                                                        .shippingCost !=
                                                    null &&
                                                widget.shippingCost!.isNotEmpty
                                            ? PriceConverter
                                                .systemCurrencyToDefaultCurrency(
                                                double.tryParse(
                                                        widget.shippingCost!) ??
                                                    0.0,
                                                context,
                                              )
                                            : 0.0;
                                        _product!.multiplyWithQuantity = multi;
                                        // _product!.brandId =
                                        //     int.tryParse(brandId ?? '') ?? 0;
                                        _product!.brandId = 1;
                                        _product!.metaTitle = metaTitle;
                                        _product!.metaDescription =
                                            metaDescription;
                                        _product!.currentStock =
                                            widget.currentStock != null &&
                                                    widget.currentStock!
                                                        .isNotEmpty
                                                ? int.tryParse(
                                                        widget.currentStock!) ??
                                                    0
                                                : 0;
                                        _product!.minimumOrderQty = widget
                                                        .minimumOrderQuantity !=
                                                    null &&
                                                widget.minimumOrderQuantity!
                                                    .isNotEmpty
                                            ? int.tryParse(widget
                                                    .minimumOrderQuantity!) ??
                                                1
                                            : 1;
                                        _product!.discountType =
                                            resProvider.discountType;
                                        _product!
                                            .digitalProductType = resProvider
                                                    .digitalProductTypeIndex ==
                                                0
                                            ? 'ready_after_sell'
                                            : 'ready_product';
                                        _product!.digitalFileReady =
                                            resProvider.digitalProductFileName;
                                        _product!.categoryIds = [
                                          CategoryIds(id: widget.categoryId)
                                        ];

                                        // Adding sub-category IDs if available
                                        if (resProvider.subCategoryIndex != 0) {
                                          _product!.categoryIds!.add(
                                              CategoryIds(
                                                  id: widget.subCategoryId));
                                        }
                                        if (resProvider.subSubCategoryIndex !=
                                            0) {
                                          _product!.categoryIds!.add(
                                              CategoryIds(
                                                  id: widget.subSubCategoryId));
                                        }

                                        // Setting color code list and language list
                                        _addProduct!.colorCodeList = List.from(
                                            resProvider.colorCodeList);
                                        _addProduct!.languageList =
                                            Provider.of<SplashController>(
                                                    context,
                                                    listen: false)
                                                .configModel!
                                                .languageList!
                                                .map((lang) => lang.code)
                                                .toList();

                                        // Handling image upload and submission
                                        if (_update) {
                                          int withColorCount = resProvider
                                              .withColor
                                              .where((c) => c.image != null)
                                              .length;
                                          int withoutColorCount = resProvider
                                              .withoutColor
                                              .where((c) => c.image != null)
                                              .length;

                                          if ((withColorCount +
                                                      withoutColorCount) <=
                                                  resProvider.totalUploaded &&
                                              resProvider.pickedLogo == null &&
                                              resProvider.pickedMeta == null) {
                                            resProvider.addProduct(
                                              context,
                                              _product!,
                                              _addProduct!,
                                              thumbnailImage,
                                              metaImage,
                                              (!_update ||
                                                  widget.isFromSuggestion ==
                                                      true),
                                              tagList,
                                            );
                                          } else {
                                            // Add product images individually if needed
                                            if (resProvider.pickedLogo !=
                                                null) {
                                              resProvider.addProductImage(
                                                  context,
                                                  resProvider.thumbnail,
                                                  route,
                                                  update: _update);
                                            }
                                            if (resProvider.pickedMeta !=
                                                null) {
                                              resProvider.addProductImage(
                                                  context,
                                                  resProvider.metaImage,
                                                  route,
                                                  update: _update);
                                            }
                                            resProvider.withColor
                                                .asMap()
                                                .forEach((i, color) {
                                              if (color.image != null) {
                                                resProvider.addProductImage(
                                                    context, color, route,
                                                    index: i, update: _update);
                                              }
                                            });
                                            resProvider.withoutColor
                                                .asMap()
                                                .forEach((i, color) {
                                              if (color.image != null) {
                                                resProvider.addProductImage(
                                                    context, color, route,
                                                    index: i, update: _update);
                                              }
                                            });
                                          }
                                        } else {
                                          // Add new product images
                                          if (resProvider.pickedLogo != null) {
                                            resProvider.addProductImage(context,
                                                resProvider.thumbnail, route);
                                          }
                                          if (resProvider.pickedMeta != null) {
                                            resProvider.addProductImage(context,
                                                resProvider.metaImage, route);
                                          }
                                          for (var color
                                              in resProvider.withColor) {
                                            resProvider.addProductImage(
                                                context, color, route);
                                          }
                                          for (var color
                                              in resProvider.withoutColor) {
                                            resProvider.addProductImage(
                                                context, color, route);
                                          }
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            )
                          : const Center(child: CircularProgressIndicator()),
                    );
                  })
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
