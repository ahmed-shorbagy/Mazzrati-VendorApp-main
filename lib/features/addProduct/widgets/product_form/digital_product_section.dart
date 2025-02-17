import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/basewidgets/custom_snackbar_widget.dart';
import '../../../../common/basewidgets/textfeild/custom_text_feild_widget.dart';
import '../../../../localization/language_constrants.dart';
import '../../../../theme/controllers/theme_controller.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/styles.dart';
import '../../controllers/add_product_controller.dart';

class DigitalProductSection extends StatelessWidget {
  const DigitalProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
      builder: (context, resProvider, _) {
        if (resProvider.productTypeIndex != 1) {
          return const SizedBox();
        }

        return Column(
          children: [
            AddProductSectionWidget(
              title: getTranslated('variation', context)!,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusDefault,
                          ),
                          border: Border.all(
                            width: .5,
                            color:
                                Theme.of(context).primaryColor.withOpacity(.7),
                          ),
                        ),
                        child: DropdownButton<String>(
                          hint: Text(
                            getTranslated('file_type', context)!,
                            style: robotoBold.copyWith(
                              color: ColorResources.getHeadTextColor(context),
                              fontSize: Dimensions.fontSizeExtraLarge,
                            ),
                          ),
                          items: ['Audio', 'Video', 'Document', 'Software']
                              .map((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value!),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (resProvider.selectedDigitalVariation
                                .contains(value)) {
                              showCustomSnackBarWidget(
                                getTranslated(
                                  'filetype_already_exists',
                                  context,
                                ),
                                context,
                                isError: true,
                              );
                            } else {
                              resProvider.addDigitalProductVariation(value!);
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      if (resProvider.selectedDigitalVariation.isNotEmpty)
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            itemCount:
                                resProvider.selectedDigitalVariation.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeVeryTiny,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeMedium,
                                  ),
                                  margin: const EdgeInsets.only(
                                    right: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.20),
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeDefault,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        resProvider
                                            .selectedDigitalVariation[index],
                                        style: robotoRegular.copyWith(
                                          color: ColorResources.titleColor(
                                              context),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: Dimensions.paddingSizeSmall,
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          resProvider.removeDigitalVariant(
                                            context,
                                            index,
                                          );
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: 15,
                                          color: ColorResources.titleColor(
                                              context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (resProvider.selectedDigitalVariation.isNotEmpty)
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                    ],
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemCount: resProvider.selectedDigitalVariation.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return AddProductSectionWidget(
                  title:
                      '${resProvider.selectedDigitalVariation[index]} ${getTranslated('extension', context)!}',
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextFieldWidget(
                            formProduct: true,
                            required: true,
                            border: true,
                            controller:
                                resProvider.extentionControllerList[index],
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.text,
                            isAmount: false,
                            hintText:
                                '${resProvider.selectedDigitalVariation[index]} ${getTranslated('extension', context)!}',
                            onFieldSubmit: (String value) {
                              if (resProvider.digitalVariationExtantion[index]
                                  .contains(value)) {
                                showCustomSnackBarWidget(
                                  getTranslated(
                                    'extension_already_exists',
                                    context,
                                  ),
                                  context,
                                  isError: true,
                                );
                              } else if (value.trim() != '') {
                                resProvider.addExtension(index, value);
                              }
                            },
                          ),
                          if (resProvider
                              .digitalVariationExtantion[index].isNotEmpty)
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                          if (resProvider
                              .digitalVariationExtantion[index].isNotEmpty)
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                itemCount: resProvider
                                    .digitalVariationExtantion[index].length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeVeryTiny,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeMedium,
                                      ),
                                      margin: const EdgeInsets.only(
                                        right: Dimensions.paddingSizeExtraSmall,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.20),
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.paddingSizeDefault,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            resProvider
                                                    .digitalVariationExtantion[
                                                index][i],
                                            style: robotoRegular.copyWith(
                                              color: ColorResources.titleColor(
                                                context,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: Dimensions.paddingSizeSmall,
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              resProvider.removeExtension(
                                                index,
                                                i,
                                              );
                                            },
                                            child: Icon(
                                              Icons.close,
                                              size: 15,
                                              color: ColorResources.titleColor(
                                                context,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

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
