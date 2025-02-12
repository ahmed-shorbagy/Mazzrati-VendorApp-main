import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/product_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/rating_bar_widget.dart';
import 'package:mazzraati_vendor_app/features/product/controllers/product_controller.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/product_model.dart';
import 'package:mazzraati_vendor_app/features/product/domain/models/suggested_product.dart';
import 'package:mazzraati_vendor_app/features/product/widgets/suggested_product_widget.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';
import 'package:mazzraati_vendor_app/utill/color_resources.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';

class SuggestedProductScreen extends StatelessWidget {
  const SuggestedProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
          title: getTranslated('suggested_product', context),
          isBackButtonExist: true),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount:
                context.read<ProductController>().suggestedProductList.length,
            itemBuilder: (context, index) {
              return SuggestedProductWidget(
                productModel: context
                    .read<ProductController>()
                    .suggestedProductList[index],
              );
            },
          )),
        ],
      ),
    );
  }
}
