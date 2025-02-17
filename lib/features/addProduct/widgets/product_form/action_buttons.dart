import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/basewidgets/custom_button_widget.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../utill/dimensions.dart';
import '../../controllers/add_product_controller.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const ActionButtons({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[
                Theme.of(context).brightness == Brightness.dark ? 800 : 200]!,
            spreadRadius: 0.5,
            blurRadius: 0.3,
          )
        ],
      ),
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: onBack,
              child: CustomButtonWidget(
                isColor: true,
                btnTxt: getTranslated('back', context),
                backgroundColor: Theme.of(context).hintColor,
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Consumer<AddProductController>(
              builder: (context, resProvider, _) {
                return CustomButtonWidget(
                  btnTxt: getTranslated('next', context),
                  onTap: onNext,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
