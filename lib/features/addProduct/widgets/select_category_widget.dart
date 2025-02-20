import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:mazzraati_vendor_app/features/addProduct/widgets/category_widget.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Product? product;
  final VoidCallback? onCategoryChanged; // Add this parameter
  const SelectCategoryWidget({
    super.key,
    required this.product,
    this.onCategoryChanged, // Add this parameter
  });

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

                          // Ensure we don't exceed the list bounds
                          if (index < resProvider.categoryList!.length) {
                            // Call setCategoryIndex with the correct index (index + 1 because 0 is for "Select Category")
                            resProvider.setCategoryIndex(index + 1, true);

                            log('Selected category: ${resProvider.categoryList![index].name!}');
                            log('Product details: ${widget.product?.toJson().toString() ?? 'No product'}');

                            // Call the onCategoryChanged callback if it's provided
                            if (widget.onCategoryChanged != null) {
                              widget.onCategoryChanged!();
                            }
                          }
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
