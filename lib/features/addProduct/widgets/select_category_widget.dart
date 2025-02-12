import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/features/addProduct/widgets/category_widget.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Product? product;
  const SelectCategoryWidget({super.key, required this.product});

  @override
  SelectCategoryWidgetState createState() => SelectCategoryWidgetState();
}

class SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  int? _selectedCategoryIndex;
  @override
  Widget build(BuildContext context) {
    log("category section===>");
    return Consumer<AddProductController>(
      builder: (context, resProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(getTranslated('select_category', context)!,
                    style: robotoRegular.copyWith(
                        color: ColorResources.titleColor(context),
                        fontSize: Dimensions.fontSizeDefault)),
                Text(
                  '*',
                  style: robotoBold.copyWith(
                      color: ColorResources.mainCardFourColor(context),
                      fontSize: Dimensions.fontSizeDefault),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            // resProvider.categoryList != null
            //     ? Container(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: Dimensions.paddingSizeSmall),
            //         decoration: BoxDecoration(
            //           color: Theme.of(context).cardColor,
            //           borderRadius:
            //               BorderRadius.circular(Dimensions.radiusDefault),
            //           border: Border.all(
            //               width: .5,
            //               color:
            //                   Theme.of(context).primaryColor.withOpacity(.7)),
            //         ),
            //         child: DropdownButton<int>(
            //             value: resProvider.categoryIndex,
            //             items: resProvider.categoryIds.map((int? value) {
            //               return DropdownMenuItem<int>(
            //                 value: resProvider.categoryIds.indexOf(value),
            //                 child: Text(value != 0
            //                     ? resProvider
            //                         .categoryList![(resProvider.categoryIds
            //                                 .indexOf(value) -
            //                             1)]
            //                         .name!
            //                     : getTranslated('select_category', context)!),
            //               );
            //             }).toList(),
            //             onChanged: (int? value) {
            //               print(
            //                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            //               print(
            //                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            //               print(
            //                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            //               resProvider.categoryList!.forEach((element) {
            //                 print(element.name);
            //                 print(element.id);
            //                 print(element.slug);
            //                 print(element.icon);
            //                 print(element.position);
            //               });

            //               print(value);
            //               print(
            //                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            //               print(
            //                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
            //               print(
            //                   "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

            //               resProvider.setCategoryIndex(value, true);
            //               resProvider.getSubCategoryList(
            //                   context,
            //                   value != 0
            //                       ? resProvider.categorySelectedIndex
            //                       : 0,
            //                   true,
            //                   widget.product);
            //             },
            //             isExpanded: true,
            //             underline: const SizedBox()))
            //     : const Center(child: CircularProgressIndicator()),
            // Row(
            //   children: [
            //     Text(getTranslated('select_category', context)!,
            //         style: robotoRegular.copyWith(
            //             color: ColorResources.titleColor(context),
            //             fontSize: Dimensions.fontSizeDefault)),
            //     Text(
            //       '*',
            //       style: robotoBold.copyWith(
            //           color: ColorResources.mainCardFourColor(context),
            //           fontSize: Dimensions.fontSizeDefault),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            resProvider.categoryList != null
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                      mainAxisSpacing: Dimensions.paddingSizeSmall,
                      childAspectRatio: .75, // Adjust this to fit your design
                    ),
                    itemCount: resProvider.categoryList!.length,
                    itemBuilder: (context, index) {
                      final category = resProvider.categoryList![index];
                      final isSelected = _selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                          resProvider.setCategoryIndex(index + 1, true);
                          log(resProvider
                              .categoryList![resProvider.categoryIndex!].name!);
                          log(widget.product!.toJson().toString());

                          // resProvider.getSubCategoryList(
                          //     context,
                          //     index != 0
                          //         ? resProvider.categorySelectedIndex
                          //         : 0,
                          //     true,
                          //     widget.product);
                        },
                        child: CategoryWidget(
                          category: category,
                          index: index,
                          length: resProvider.categoryList!.length,
                          isSelected: widget.product != null
                              ? resProvider.categoryIndex! - 1 == index
                                  ? true
                                  : isSelected
                              : isSelected,
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        );
      },
    );
  }
}
//!!!!!!!!!!!!!!!
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:mazzraati_vendor_app/features/addProduct/widgets/category_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
// import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
// import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
// import 'package:mazzraati_vendor_app/utill/color_resources.dart';
// import 'package:mazzraati_vendor_app/utill/dimensions.dart';
// import 'package:mazzraati_vendor_app/utill/styles.dart';
// import 'package:mazzraati_vendor_app/features/addProduct/domain/models/category_model.dart';
// import 'package:mazzraati_vendor_app/common/basewidgets/custom_image_widget.dart';
// import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';

// class SelectCategoryWidget extends StatefulWidget {
//   final Product? product;
//   const SelectCategoryWidget({super.key, required this.product});

//   @override
//   SelectCategoryWidgetState createState() => SelectCategoryWidgetState();
// }

// class SelectCategoryWidgetState extends State<SelectCategoryWidget> {
//   int? _selectedCategoryIndex;

//   @override
//   Widget build(BuildContext context) {
//     log("category section===>");
//     return Consumer<AddProductController>(
//       builder: (context, resProvider, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Text(getTranslated('select_category', context)!,
//                     style: robotoRegular.copyWith(
//                         color: ColorResources.titleColor(context),
//                         fontSize: Dimensions.fontSizeDefault)),
//                 Text(
//                   '*',
//                   style: robotoBold.copyWith(
//                       color: ColorResources.mainCardFourColor(context),
//                       fontSize: Dimensions.fontSizeDefault),
//                 ),
//               ],
//             ),
//             const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//             resProvider.categoryList != null
//                 ? GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                       crossAxisSpacing: Dimensions.paddingSizeSmall,
//                       mainAxisSpacing: Dimensions.paddingSizeSmall,
//                       childAspectRatio: .75, // Adjust this to fit your design
//                     ),
//                     itemCount: resProvider.categoryList!.length,
//                     itemBuilder: (context, index) {
//                       final category = resProvider.categoryList![index];
//                       final isSelected = _selectedCategoryIndex == index;
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedCategoryIndex = index;
//                           });
//                           resProvider.setCategoryIndex(index, true);
//                           log(resProvider
//                               .categoryList![resProvider.categoryIndex!].name!);
//                           // resProvider.getSubCategoryList(
//                           //     context,
//                           //     index != 0
//                           //         ? resProvider.categorySelectedIndex
//                           //         : 0,
//                           //     true,
//                           //     widget.product);
//                           log(resProvider.categoryList.toString());
//                         },
//                         child: CategoryWidget(
//                           category: category,
//                           index: index,
//                           length: resProvider.categoryList!.length,
//                           isSelected: isSelected,
//                         ),
//                       );
//                     },
//                   )
//                 : const Center(child: CircularProgressIndicator()),
//             const SizedBox(height: Dimensions.paddingSizeSmall),
//           ],
//         );
//       },
//     );
//   }
// }
