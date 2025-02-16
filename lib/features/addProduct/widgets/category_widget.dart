// import 'package:flutter/material.dart';
// import 'package:mazzraati_vendor_app/common/basewidgets/custom_image_widget.dart';
// import 'package:mazzraati_vendor_app/features/addProduct/domain/models/category_model.dart';
// import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
// import 'package:mazzraati_vendor_app/utill/color_resources.dart';
// import 'package:mazzraati_vendor_app/utill/dimensions.dart';
// import 'package:mazzraati_vendor_app/utill/styles.dart';

// import 'package:provider/provider.dart';

// class CategoryWidget extends StatelessWidget {
//   final CategoryModel category;
//   final int index;
//   final int length;
//   const CategoryWidget(
//       {super.key,
//       required this.category,
//       required this.index,
//       required this.length});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//           left:
//               Provider.of<LocalizationController>(context, listen: false).isLtr
//                   ? 16
//                   : 0,
//           right: index + 1 == length
//               ? Dimensions.paddingSizeDefault
//               : Provider.of<LocalizationController>(context, listen: false)
//                       .isLtr
//                   ? 0
//                   : 16),
//       child: Column(children: [
//         Container(
//             height: MediaQuery.of(context).size.width / 6.5,
//             width: MediaQuery.of(context).size.width / 6.5,
//             decoration: BoxDecoration(
//                 border: Border.all(
//                     color: Theme.of(context).primaryColor.withOpacity(.125),
//                     width: .25),
//                 borderRadius:
//                     BorderRadius.circular(Dimensions.paddingSizeSmall),
//                 color: Theme.of(context).primaryColor.withOpacity(.125)),
//             child: ClipRRect(
//                 borderRadius:
//                     BorderRadius.circular(Dimensions.paddingSizeSmall),
//                 child: CustomImageWidget(
//                     image: '${category.imageFullUrl?.path}'))),
//         const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//         Center(
//             child: SizedBox(
//                 width: MediaQuery.of(context).size.width / 6.5,
//                 child: Text(category.name ?? '',
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: textRegular.copyWith(
//                         fontSize: Dimensions.fontSizeSmall,
//                         color: ColorResources.getTextTitle(context)))))
//       ]),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:mazzraati_vendor_app/features/addProduct/domain/models/category_model.dart';
import 'package:mazzraati_vendor_app/localization/controllers/localization_controller.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';
import 'package:mazzraati_vendor_app/utill/images.dart';
import 'package:mazzraati_vendor_app/utill/styles.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final int length;
  final bool isSelected;
  const CategoryWidget(
      {super.key,
      required this.category,
      required this.index,
      required this.length,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
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

    String displayName = category.getTranslatedName(languageCode);

    return Padding(
      padding: EdgeInsets.only(
          left:
              Provider.of<LocalizationController>(context, listen: false).isLtr
                  ? 16
                  : 0,
          right: index + 1 == length
              ? Dimensions.paddingSizeDefault
              : Provider.of<LocalizationController>(context, listen: false)
                      .isLtr
                  ? 0
                  : 16),
      child: Column(children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            borderRadius:
                BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3)
            ],
          ),
          child: CustomImageWidget(
            fit: BoxFit.cover,
            placeholder: Images.placeholderImage,
            image: category.iconFullUrl?.path ?? '',
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        SizedBox(
          width: 70,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
