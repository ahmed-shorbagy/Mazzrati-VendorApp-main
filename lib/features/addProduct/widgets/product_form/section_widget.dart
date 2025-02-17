import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme/controllers/theme_controller.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';

class AddProductSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AddProductSectionWidget({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: Dimensions.paddingSizeSmall,
        bottom: Dimensions.paddingSizeSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[
                Provider.of<ThemeController>(context).darkTheme ? 800 : 200]!,
            spreadRadius: 0.5,
            blurRadius: 0.3,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeDefault,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: robotoBold.copyWith(
                    color: ColorResources.getHeadTextColor(context),
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ),
                ),
                ...children,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
